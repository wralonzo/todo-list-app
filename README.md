# Flutter To-Do List App

A **To-Do List** application built with **Flutter** that helps users manage tasks efficiently. This app follows the **Clean Architecture** principles and implements **provider** for state management. It integrates with an external API to handle tasks and includes a login and registration flow for user authentication.

## Features

- **Login & Register**: Secure login and registration using an external API.
- **Add Tasks**: Form to add new tasks (Title, Description, Due Date).
- **Edit Tasks**: Modify task details.
- **Delete Tasks**: Remove tasks from the list.
- **Task Completion**: Mark tasks as completed or incomplete.
- **Task Filtering**: Filter tasks by status (All, Completed, Pending).
- **Sorting**: Sort tasks by due date, title, or status.
- **Drag & Drop**: Reorder tasks using drag-and-drop functionality.
- **Task Notifications**: Receive notifications for tasks with approaching deadlines.
- **State Management**: Managed using **Provider**.
- **API Integration**: Tasks are synced with a remote API.
- **Clean Architecture**: Code structure follows best practices with separation of concerns.

## Screenshots

![Login Screen](screenshots/login_screen.png)
![Task List](screenshots/task_list.png)
![Add Task](screenshots/add_task.png)

## Installation

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK
- Android Studio / Xcode
- A running backend API for tasks (API details need to be configured in the app).

### Steps

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/todo-flutter-app.git
