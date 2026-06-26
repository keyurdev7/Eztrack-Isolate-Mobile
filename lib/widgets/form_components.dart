import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eztrack_rental/theme/color.dart';
import 'dart:io';

class FormTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController? controller;
  final bool isRequired;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;

  const FormTextField({
    Key? key,
    required this.label,
    required this.placeholder,
    this.controller,
    this.isRequired = false,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRequired ? '$label*' : label,
          style: TextStyle(
            fontSize: 14,
            color: mainTextColor,
            fontWeight: FontWeight.w500,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          validator: validator,
          inputFormatters: inputFormatters,
          style: TextStyle(
            fontSize: 14,
            color: mainTextColor,
            fontWeight: FontWeight.w400,
            fontFamily: 'BricolageGrotesque',
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 14,
              color: lightGray,
              fontWeight: FontWeight.w400,
              fontFamily: 'BricolageGrotesque',
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFFE5E5EA), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: white,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

class FormDropdownField extends StatelessWidget {
  final String label;
  final String placeholder;
  final String? selectedValue;
  final List<String> items;
  final bool isRequired;
  final void Function(String?)? onChanged;

  const FormDropdownField({
    Key? key,
    required this.label,
    required this.placeholder,
    this.selectedValue,
    required this.items,
    this.isRequired = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRequired ? '$label*' : label,
          style: TextStyle(
            fontSize: 14,
            color: mainTextColor,
            fontWeight: FontWeight.w500,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 14,
            color: mainTextColor,
            fontWeight: FontWeight.w400,
            fontFamily: 'BricolageGrotesque',
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 14,
              color: lightGray,
              fontWeight: FontWeight.w400,
              fontFamily: 'BricolageGrotesque',
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color(0xFFE5E5EA), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: white,
          //  suffixIcon: const Icon(Icons.keyboard_arrow_down, color: lightGray),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 14,
                  color: mainTextColor,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'BricolageGrotesque',
                ),
              ),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((String item) {
              return Text(
                item,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 14,
                  color: mainTextColor,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'BricolageGrotesque',
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}

class FormDateField extends StatelessWidget {
  final String label;
  final String? selectedDate;
  final bool isRequired;
  final VoidCallback onTap;

  const FormDateField({
    Key? key,
    required this.label,
    this.selectedDate,
    this.isRequired = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRequired ? '$label*' : label,
          style: TextStyle(
            fontSize: 14,
            color: mainTextColor,
            fontWeight: FontWeight.w500,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              // color: primary,
              color: bottomBarTextColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: white, size: 16),
                const SizedBox(width: 8),
                Text(
                  selectedDate ?? 'SELECT DATE',
                  style: const TextStyle(
                    fontSize: 14,
                    color: white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'BricolageGrotesque',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FormToggleField extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const FormToggleField({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: mainTextColor,
            fontWeight: FontWeight.w500,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: primary,
        ),
      ],
    );
  }
}

class FormUploadButtons extends StatelessWidget {
  final VoidCallback onUploadPhoto;
  final VoidCallback onCapture;
  final File? selectedImage;
  final VoidCallback? onRemoveImage;

  const FormUploadButtons({
    Key? key,
    required this.onUploadPhoto,
    required this.onCapture,
    this.selectedImage,
    this.onRemoveImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Form',
          style: TextStyle(
            fontSize: 14,
            color: mainTextColor,
            fontWeight: FontWeight.w500,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        const SizedBox(height: 12),
        if (selectedImage != null) ...[
          _buildImagePreview(),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(
              child: _buildUploadButton(
                icon: Icons.upload,
                label: 'Upload Photo',
                onTap: onUploadPhoto,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildUploadButton(
                icon: Icons.camera_alt,
                label: 'Capture',
                onTap: onCapture,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: primary, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primary, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: primary,
                fontWeight: FontWeight.w500,
                fontFamily: 'BricolageGrotesque',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5EA), width: 1),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              selectedImage!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onRemoveImage,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.close,
                  color: white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FormCostsSection extends StatelessWidget {
  final VoidCallback onAddCost;

  const FormCostsSection({
    Key? key,
    required this.onAddCost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Costs',
          style: TextStyle(
            fontSize: 14,
            color: mainTextColor,
            fontWeight: FontWeight.w500,
            fontFamily: 'BricolageGrotesque',
          ),
        ),
        GestureDetector(
          onTap: onAddCost,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: white, size: 20),
          ),
        ),
      ],
    );
  }
}

class FormSubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const FormSubmitButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      color: white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'BricolageGrotesque',
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
