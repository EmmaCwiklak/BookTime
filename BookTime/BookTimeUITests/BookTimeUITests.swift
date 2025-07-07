import XCTest

final class BookTimeUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testLogin() throws {
        // 1. Logowanie
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText("proba1@mail.com")
        
        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText("proba1@mail")
        app.scrollViews.firstMatch.swipeUp()
        app.buttons["Log in"].tap()

        sleep(5)
    }
    
    func testToggleFavoriteUpdatesIconAndFilters() {
        
        app.scrollViews.firstMatch.swipeUp()
        let commentsButton = app.buttons["Comments"]
        
            XCTAssertTrue(commentsButton.waitForExistence(timeout: 5), "Comments button not found")
            commentsButton.tap()

        let favoritesToggle = app.switches["Show favourites Only"]
        
        //let exists = firstReviewCell.waitForExistence(timeout: 10)
       // XCTAssertTrue(exists, "First review cell should appear")
        
        let predicate = NSPredicate(format: "identifier BEGINSWITH %@", "FavoriteIcon_")
        let favoriteIcon = app.buttons.matching(predicate).firstMatch

        // 1. Upewnij się, że widok się pojawił
        XCTAssertTrue(favoritesToggle.waitForExistence(timeout: 5), "Favorites toggle should appear")
        

        // 2. Tap favorite icon (toggle favorite state)
        let originalIcon = favoriteIcon.label
        favoriteIcon.tap()

        // 3. Poczekaj chwilę na update Firebase/UI
        sleep(2)

        // 4. Sprawdź czy ikona się zmieniła
        let updatedIcon = favoriteIcon.label
        XCTAssertNotEqual(originalIcon, updatedIcon, "Icon should change after tapping")

        // 5. Włącz filtr
        favoritesToggle.tap()
        sleep(1)

        // 7. Cofnij (odznacz jako ulubiony)
        favoriteIcon.tap()
    }

}

