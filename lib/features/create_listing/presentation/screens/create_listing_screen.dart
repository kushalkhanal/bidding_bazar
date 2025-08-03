import 'dart:io';
import 'package:bidding_bazar/core/di/service_locator.dart';
import 'package:bidding_bazar/features/create_listing/domain/usecases/create_bidding_room.dart';
import 'package:bidding_bazar/features/create_listing/presentation/cubit/create_listing_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime? _endTime;
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    var status = await Permission.photos.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo library permission is required to select images.')));
      return;
    }

    if (_images.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You can only upload a maximum of 5 images.')));
      return;
    }

    final List<XFile> pickedFiles = await _picker.pickMultiImage(
      limit: 5 - _images.length,
    );

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _selectDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date == null) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1))),
    );
    if (time == null) return;

    setState(() {
      _endTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CreateListingCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Create New Listing')),
        body: BlocConsumer<CreateListingCubit, CreateListingState>(
          listener: (context, state) {
            if (state is CreateListingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listing created successfully!'), backgroundColor: Colors.green));
              Navigator.of(context).pop(true); // Pop with a result to indicate success
            }
            if (state is CreateListingFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.message}'), backgroundColor: Colors.red));
            }
          },
          builder: (context, state) {
            final isLoading = state is CreateListingLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image Picker UI
                    Container(
                      padding: const EdgeInsets.all(8),
                      height: 150,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                      child: _images.isEmpty
                          ? Center(child: TextButton.icon(icon: const Icon(Icons.add_a_photo), label: const Text('Add Images (Up to 5)'), onPressed: _pickImages))
                          : GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 8, crossAxisSpacing: 8),
                              itemCount: _images.length < 5 ? _images.length + 1 : 5,
                              itemBuilder: (context, index) {
                                if (index == _images.length) {
                                  return IconButton.filledTonal(icon: const Icon(Icons.add), onPressed: _pickImages);
                                }
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(child: Image.file(File(_images[index].path), fit: BoxFit.cover)),
                                      Positioned(
                                        top: -10, right: -10,
                                        child: IconButton(
                                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                                          onPressed: () => _removeImage(index),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Item Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3, validator: (v) => v!.isEmpty ? 'Required' : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _priceController, decoration: const InputDecoration(labelText: 'Starting Price', prefixText: '\$'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Auction End Time'),
                      subtitle: Text(_endTime == null ? 'Not set' : DateFormat.yMd().add_jm().format(_endTime!)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _selectDateTime,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade400)),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: isLoading ? null : () {
                        if (_formKey.currentState!.validate() && _endTime != null && _images.isNotEmpty) {
                          context.read<CreateListingCubit>().createListing(CreateBiddingRoomParams(
                            name: _nameController.text.trim(),
                            description: _descriptionController.text.trim(),
                            startingPrice: double.parse(_priceController.text),
                            endTime: _endTime!,
                            images: _images,
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields and add at least one image.')));
                        }
                      },
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Submit Listing'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}