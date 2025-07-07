//
//  ReadingTimeViewModel.swift
//  BookTime
//
//  Created by Emma on 05/05/2025.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth

class ReadingTimeViewModel {
    func saveReadingSpeed(_ speed: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Auth", code: 401)))
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(userId).setData(["readingSpeed": speed], merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}