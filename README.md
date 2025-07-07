# BookTime – Personal Book Tracker App for iOS

BookTime is a mobile application built with SwiftUI and Firebase that helps users track their reading habits, manage book collections, and write reviews. The app offers a seamless and intuitive interface for logging reading progress, adding favorite books, and estimating reading time based on user behavior.

## Features

- **Secure Login & Registration**
  - Email/password authentication with Firebase
  - Google Sign-In support

- **Search & Explore**
  - Book search using the Google Books API
  - Filter by language (English & Polish)
  - View detailed book information (cover, title, author, page count, etc.)

- **Manage Books**
  - Categorize books as: *Read*, *Currently Reading*, or *Want to Read*
  - Add/remove books from *Favorites*
  - Save books for later reading

-  **User Reviews & Notes**
  - Write comments and notes about books
  - Edit and delete existing reviews
  - Highlight favorite notes

- **Reading Time Estimation**
  - Built-in reading speed test using a sample text
  - Estimate reading time for any book based on personal speed

- **Settings & Profile**
  - View reading speed
  - Log out and manage session
  - Access personalized book lists and notes

## Technologies Used

- **SwiftUI** – UI Framework for declarative interface design
- **Firebase Auth & Firestore** – Authentication and NoSQL database
- **Google Books API** – Fetch book metadata and cover images
- **MVVM Architecture** – Clean separation of logic and UI

## Screenshots
## 📸 Screenshots

### Signing up
![Sign Up](screenshots/SignUp.png)

### Librqry
![Library](screenshots/Library.png)

### Comments
![All Comments](screenshots/All_Comments.png)
## Security & Data Handling

- All book images are loaded securely using `https` links
- User data is stored securely in Firebase Firestore under unique user IDs
- No sensitive user information is stored locally
- Authentication managed via Firebase Auth + Google Sign-In

