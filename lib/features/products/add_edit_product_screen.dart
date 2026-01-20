import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/product.dart';
import '../../providers/products_provider.dart';

class AddEditProductScreen extends ConsumerStatefulWidget {
  final Product? product; // If null, it's add mode; otherwise edit mode
  
  const AddEditProductScreen({super.key, this.product});

  @override
  ConsumerState<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends ConsumerState<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _stockController;
  late String _selectedCategory;
  
  bool get isEditMode => widget.product != null;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _barcodeController = TextEditingController(text: widget.product?.barcode ?? '');
    _stockController = TextEditingController(text: widget.product?.stockQuantity.toString() ?? '0');
    _selectedCategory = widget.product?.category ?? AppConstants.defaultCategories.firstWhere((c) => c != 'All');
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _barcodeController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Product' : 'Add Product'),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Product Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Product Name *',
                hintText: 'Enter product name',
                prefixIcon: Icon(Iconsax.box, color: AppColors.primary),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Product name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter product description',
                prefixIcon: Icon(Iconsax.document_text, color: AppColors.primary),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            
            // Price
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price *',
                hintText: 'Enter price',
                prefixIcon: Icon(Iconsax.money, color: AppColors.primary),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Price is required';
                }
                if (double.tryParse(value) == null) {
                  return 'Enter a valid price';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Barcode
            TextFormField(
              controller: _barcodeController,
              decoration: InputDecoration(
                labelText: 'Barcode',
                hintText: 'Enter barcode (optional)',
                prefixIcon: Icon(Iconsax.scan_barcode, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            
            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category *',
                prefixIcon: Icon(Iconsax.category, color: AppColors.primary),
              ),
              items: AppConstants.defaultCategories
                .where((c) => c != 'All')
                .map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Stock Quantity
            TextFormField(
              controller: _stockController,
              decoration: InputDecoration(
                labelText: 'Stock Quantity *',
                hintText: 'Enter stock quantity',
                prefixIcon: Icon(Iconsax.box_tick, color: AppColors.primary),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Stock quantity is required';
                }
                if (int.tryParse(value) == null) {
                  return 'Enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            
            // Save Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _saveProduct,
                child: Text(
                  isEditMode ? 'Update Product' : 'Add Product',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  
  void _saveProduct() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final price = double.parse(_priceController.text);
    final barcode = _barcodeController.text.trim();
    final stock = int.parse(_stockController.text);
    
    if (isEditMode) {
      // Update existing product
      final updatedProduct = widget.product!.copyWith(
        name: name,
        description: description.isEmpty ? null : description,
        price: price,
        barcode: barcode.isEmpty ? null : barcode,
        category: _selectedCategory,
        stockQuantity: stock,
        updatedAt: DateTime.now(),
      );
      ref.read(productsProvider.notifier).updateProduct(updatedProduct);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully')),
      );
    } else {
      // Create new product
      ref.read(productsProvider.notifier).createProduct(
        name: name,
        description: description.isEmpty ? null : description,
        price: price,
        barcode: barcode.isEmpty ? null : barcode,
        category: _selectedCategory,
        stockQuantity: stock,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully')),
      );
    }
    
    Navigator.pop(context);
  }
}
