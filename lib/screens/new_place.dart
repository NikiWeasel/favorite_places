import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/provider/place_provider.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'dart:io';
import 'package:favorite_places/widgets/location_input.dart';

class NewPlaceScreen extends ConsumerStatefulWidget {
  NewPlaceScreen({super.key});

  @override
  ConsumerState<NewPlaceScreen> createState() {
    return NewPlaceState();
  }
}

class NewPlaceState extends ConsumerState<NewPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  File? _selectedImage;
  PlaceLocation? _pickedLocation;

  void saveInput() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    ref
        .read(placesProvider.notifier)
        .addPlace(_title, _selectedImage!, _pickedLocation!);
    // ref
    //     .read(favoriteMealsProvider.notifier)
    //     .toggleMealFavoriteStatus(meal);
    //todo riverpod
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMeals = ref.watch(placesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Center(
                  child: SizedBox(
                    width: 400,
                    child: TextFormField(
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                      validator: (value) {
                        if (value == '' ||
                            value == null ||
                            _selectedImage == null) {
                          return 'Error';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _title = value!;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ImageInput(
                  onSelectImage: (File image) {
                    _selectedImage = image;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                LocationInput(
                  onSelectLocation: (PlaceLocation location) {
                    _pickedLocation = location;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 125,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: saveInput,
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        Text('Add place'),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
