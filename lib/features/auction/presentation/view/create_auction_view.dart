import 'dart:io';
import 'package:bidding_bazar/features/auction/presentation/view_model/create_auction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateAuctionView extends StatefulWidget {
  const CreateAuctionView({super.key});

  @override
  State<CreateAuctionView> createState() => _CreateAuctionViewState();
}

class _CreateAuctionViewState extends State<CreateAuctionView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startingPriceController = TextEditingController();
  final _imagePicker = ImagePicker();
  List<File> _selectedImages = [];
  DateTime? _selectedEndTime;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _startingPriceController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (images.isNotEmpty) {
        setState(() {
          _selectedImages = images.map((image) => File(image.path)).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: $e')),
      );
    }
  }

  Future<void> _selectEndTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedEndTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _createAuction() {
    if (_formKey.currentState!.validate() && _selectedEndTime != null) {
      context.read<CreateAuctionViewModel>().createAuction(
        name: _nameController.text,
        description: _descriptionController.text,
        startingPrice: double.parse(_startingPriceController.text),
        endTime: _selectedEndTime!,
        images: _selectedImages,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Auction'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: BlocListener<CreateAuctionViewModel, CreateAuctionState>(
        listener: (context, state) {
          if (state is CreateAuctionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Auction created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is CreateAuctionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<CreateAuctionViewModel, CreateAuctionState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSection(),
                    const SizedBox(height: 24),
                    _buildFormFields(),
                    const SizedBox(height: 32),
                    _buildCreateButton(state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Auction Images',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Add up to 5 images (max 5MB each)',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _selectedImages.isEmpty
              ? _buildEmptyImageState()
              : _buildImageGrid(),
        ),
      ],
    );
  }

  Widget _buildEmptyImageState() {
    return InkWell(
      onTap: _pickImages,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('Add Images', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return Stack(
      children: [
        GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _selectedImages.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImages.removeAt(index);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        if (_selectedImages.length < 5)
          Positioned(
            bottom: 8,
            right: 8,
            child: FloatingActionButton.small(
              onPressed: _pickImages,
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Auction Name',
            hintText: 'Enter auction name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter auction name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Description',
            hintText: 'Enter auction description',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter description';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _startingPriceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Starting Price (\$)',
            hintText: 'Enter starting price',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.attach_money),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter starting price';
            }
            final price = double.tryParse(value);
            if (price == null || price <= 0) {
              return 'Please enter a valid price';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _selectEndTime,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedEndTime != null
                        ? 'End Time: ${_selectedEndTime!.toString().substring(0, 16)}'
                        : 'Select End Time',
                    style: TextStyle(
                      color: _selectedEndTime != null ? Colors.black : Colors.grey[600],
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
        if (_selectedEndTime == null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              'Please select end time',
              style: TextStyle(color: Colors.red[600], fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildCreateButton(CreateAuctionState state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: state is CreateAuctionLoading ? null : _createAuction,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: state is CreateAuctionLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Create Auction',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
} 