//
//  AppViewModelTests.swift
//  VitesseTests
//
//  Created by Alexandre Talatinian on 13/01/2025.
//

import XCTest
@testable import Vitesse

final class AppViewModelTests: XCTestCase {
    
    func test_init_startsWithDefaultState() {
        let sut = AppViewModel()
        
        XCTAssertFalse(sut.isLogged)
        XCTAssertFalse(sut.isAdmin)
    }
    
    @MainActor
    func test_loginViewModel_updateStateOnSuccessfulLogin() async {
        let sut = AppViewModel()
        let loginVM = sut.authenticationViewModel
        
        loginVM.onLoginSucceed(true)
        
        // Wait for the next run loop
        await Task.yield()
        
        XCTAssertTrue(sut.isLogged)
        XCTAssertTrue(sut.isAdmin)
    }

    @MainActor
    func test_loginViewModel_updatesStateAsNonAdmin() async {
        let sut = AppViewModel()
        let loginVM = sut.authenticationViewModel
        
        loginVM.onLoginSucceed(false)
        
        // Wait for the next run loop
        await Task.yield()
        
        XCTAssertTrue(sut.isLogged)
        XCTAssertFalse(sut.isAdmin)
    }

    @MainActor
    func test_candidatesViewModel_reflectsCurrentAdminStatus() async {
        let sut = AppViewModel()
        
        let initialViewModel = sut.candidatesViewModel
        XCTAssertFalse(initialViewModel.isAdmin)
        
        let loginVM = sut.authenticationViewModel
        loginVM.onLoginSucceed(true)
        
        // Wait for the next run loop
        await Task.yield()
        
        let updatedViewModel = sut.candidatesViewModel
        XCTAssertTrue(updatedViewModel.isAdmin)
    }
    
    @MainActor
    func test_weakSelfReference_preventsCaptureInLoginCallback() {
        // 1. Create an optional AppViewModel
        var sut: AppViewModel? = AppViewModel()
        weak var weakSut = sut
        
        // 2. Safely get and store the LoginViewModel before we nil out sut
        let loginVM = sut?.authenticationViewModel
        
        // 3. Remove our strong reference to AppViewModel
        sut = nil
        
        // 4. Safely unwrap loginVM to call onLoginSucceed
        loginVM?.onLoginSucceed(true)
        
        // 5. Verify our weak reference is nil
        XCTAssertNil(weakSut, "AppViewModel should be deallocated")
    }
}
