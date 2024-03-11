## Envo Mobile - Flutter App

This is the README file for the Envo Mobile Flutter app.

**Description:**

Envo Mobile is a mobile application that allows users to take actions to reduce their carbon footprint and earn rewards. Users can post about their eco-friendly actions, participate in surveys, and track their progress.

**Getting Started:**

1. **Clone the repository:**

```bash
git clone https://your-github-repo-url.git
```

2. **Install dependencies:**

```bash
cd envo_mobile
flutter pub get
```

3. **Run the app:**

```bash
flutter run
```

**Project Structure:**

```
envo_mobile/
  - analysis_options.yaml (Contains linting rules)
  - android/ (Android specific code)
  - assets/ (Assets used in the app)
  - ios/ (iOS specific code)
  - lib/ (Dart source code)
      - main.dart (Application entry point)
      - models/ (Data models for the app)
          - action_model.dart
          - leaderboard_model.dart
          - post_model.dart
          - rewards_model.dart
          - survey_model.dart
          - user_model.dart
      - modules/ (Modules for different functionalities)
      - repositories/ (Data repositories)
      - utils/ (Utility functions)
  - pubspec.lock (Dependencies lock file)
  - pubspec.yaml (Project configuration file)
  - test/ (Unit tests)
  - web/ (Web version of the app)
  - windows/ (Windows specific code)
  - README.md (This file)
```

**Dependencies:**

This project uses various Flutter packages for functionalities like:

* State management (Bloc, GetX)
* Networking (http, dio)
* UI elements (Cupertino Icons, cached_network_image)
* Image manipulation (image_picker)
* Data validation (email_validator)
* Fonts (google_fonts)
* Navigation (flutter_launcher_icons)

For a complete list of dependencies, refer to the `pubspec.yaml` file.

**Functionality:** Posting an eco-friendly action by a user.

**Explanation:**

1. **Model (lib/models/action_model.dart):**

This file defines the data structure for an eco-friendly action.

```dart
class ActionModel {
  final String title; // Title of the action (e.g., Used a reusable water bottle)
  final String description; // Optional description of the action
  final DateTime timestamp; // Date and time the action was posted

  ActionModel({required this.title, this.description, required this.timestamp});
}
```

2. **Create Post Screen (lib/modules/post_action/screens/create_post_screen.dart):**

This file contains the UI and logic for the screen where users create a new post about their eco-friendly action.

```dart
class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Function to submit the post
  void _submitPost() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final timestamp = DateTime.now();

    // Create ActionModel object
    final action = ActionModel(title: title, timestamp: timestamp, description: description);

    // Use a repository class to save the action (implementation omitted)
    await ActionRepository.saveAction(action);

    // Navigate back to the main screen after successful post
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description (Optional)'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Explanation of the Code:**

* `ActionModel` class defines the data for a user's eco-friendly action.
* `CreatePostScreen` allows users to enter a title, optional description, and submit the post.
* `_submitPost` function retrieves user input, creates an `ActionModel` object, and saves it using the `ActionRepository` (implementation omitted for brevity). 
* This example demonstrates a basic structure for user input and saving data. Real-world applications would involve additional functionalities like user authentication, database interaction, and error handling.

I hope this breakdown provides a better understanding of how code plays a role in building functionalities within the Envo Mobile app. 

I can't directly display colors in the response, but I can provide instructions on how to incorporate the colors from `utils/meta_colors.dart` into your README with a palette example:

**Color Palette**

The Envo Mobile app utilizes a carefully chosen color palette to enhance the user experience. These colors are defined in the `utils/meta_colors.dart` file. Here's a sample palette showcasing some of the key colors:

```
| Color Name           | Hex Code          | Description                                 |
|----------------------|--------------------|----------------------------------------------|
| Primary Color        | #00e0eb           | The main brand color of the app.             |
| Secondary Color     | #33167c           | A contrasting color used for accents.        |
| Text Color           | #282828           | Color for primary text content.              |
| Secondary Text Color | #7C86A1           | Color for secondary text or labels.          |
| Bottom Nav Gradient 1 | #00cad4           | First color in the bottom navigation gradient. |
| Bottom Nav Gradient 2 | #00f0fb           | Second color in the bottom navigation gradient. |
```

**API ENDPOINTS**

The Envo Mobile app utilizes Rest Framework API's you can refer to meta_strings.dart in util folder



**Additional Notes:**

* You can expand this table to include more colors from `meta_colors.dart`.
* Consider using a color palette generator online to create a visual representation of your app's colors. You can then link to that image in your README for a more user-friendly experience.

By incorporating the color palette into your README, you provide users with a clear understanding of the app's visual identity.


**Customization:**

* You can customize the app's theme by changing the values in `main.dart`.
* You can add new functionalities by creating new modules and models.


**Further Information:**

For more information about the Envo Mobile app or Flutter development, refer to the following resources:

* Flutter documentation: [https://docs.flutter.dev/](https://docs.flutter.dev/)
* GetX documentation: [https://pub.dev/packages/get](https://pub.dev/packages/get)


