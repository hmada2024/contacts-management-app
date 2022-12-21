import 'package:firebase_cli/theme/theme.dart';
import 'package:firebase_cli/utils/my_firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({Key? key}) : super(key: key);

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
  }

  // TODO: Add contact to Firebase
  void addContact() async {
    if (_formKey.currentState!.validate()) {
      try {
        await MyFirebase.contactsCollection.add({
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
        });
        Navigator.pop(context);
      } on FirebaseException {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to add contact'),
            backgroundColor: Colors.red[300],
          ),
        );
      }
    } else {
      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all the fields'),
          backgroundColor: Colors.red[300],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Contact"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: "Name",
                    contentPadding: inputPadding,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: phoneController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a phone number";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Phone",
                    contentPadding: inputPadding,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter an email";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    contentPadding: inputPadding,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton.icon(
                      onPressed: addContact,
                      icon: const Icon(IconlyBroken.add_user),
                      label: const Text("Save")),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
