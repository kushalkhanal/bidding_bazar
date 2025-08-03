import 'package:flutter/material.dart';

class PlaceBidDialog extends StatefulWidget {
  final double currentPrice;
  final Function(double) onBidPlaced;

  const PlaceBidDialog({
    super.key,
    required this.currentPrice,
    required this.onBidPlaced,
  });

  @override
  State<PlaceBidDialog> createState() => _PlaceBidDialogState();
}

class _PlaceBidDialogState extends State<PlaceBidDialog> {
  final _formKey = GlobalKey<FormState>();
  final _bidController = TextEditingController();

  @override
  void dispose() {
    _bidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Place Your Bid'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current highest bid is \$${widget.currentPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bidController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Your Bid Amount',
                prefixText: '\$ ',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a bid amount.';
                }
                final amount = double.tryParse(value);
                if (amount == null) {
                  return 'Please enter a valid number.';
                }
                if (amount <= widget.currentPrice) {
                  return 'Your bid must be higher than the current price.';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final amount = double.parse(_bidController.text);
              widget.onBidPlaced(amount);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Submit Bid'),
        ),
      ],
    );
  }
}