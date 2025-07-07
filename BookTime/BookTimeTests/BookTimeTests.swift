//
//  BookTimeTests.swift
//  BookTimeTests
//
//  Created by Emma on 24/06/2024.
//

import XCTest
@testable import BookTime

final class BookTimeTests: XCTestCase {

//        func testPasswordValidation() {
//            let viewModel = RegisterViewModel()
//            
//            viewModel.password = "abc"
//            XCTAssertFalse(viewModel.isPasswordValid
//            
//            viewModel.password = "Abc123!"
//            XCTAssertFalse(viewModel.isPasswordValid)
//
//            viewModel.password = "Abc123!@#"
//            XCTAssertTrue(viewModel.isPasswordValid)
//        }

        func testPasswordsMatching() {
            let viewModel = RegisterViewModel()
            
            viewModel.password = "Test123!"
            viewModel.confirmPassword = "Test123!"
            XCTAssertTrue(viewModel.doPasswordsMatch)

            viewModel.confirmPassword = "Mismatch123!"
            XCTAssertFalse(viewModel.doPasswordsMatch)
        }
    
}


