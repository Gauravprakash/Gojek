//
//  Gojek_DemoTests.swift
//  Gojek DemoTests
//
//  Created by Gaurav Prakash on 07/08/19.
//  Copyright © 2019 Gaurav. All rights reserved.
//

import XCTest
import Moya
@testable import Gojek_Demo

class Gojek_DemoTests: XCTestCase {
   var viewModel: ContactListViewModel!
    override func setUp() {
        viewModel = ContactListViewModel()
        viewModel.apiProvider = MoyaProvider<API>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testFetchWithSuccessService() {
        self.viewModel.fetchContacts()
        XCTAssertTrue(self.viewModel.contactArray.count == 20)
    }


    override func tearDown() {
        viewModel = nil
    }
    
    func testDeliveryDetailsViewModel() {
        let contact = Contact(id: 8882, firstName: "test", lastName: "kumar", profilePic: "/images/missing.png", favorite: false, phoneNumber: "+9178976585", emailId: "test@gmail.com", url: "https://gojek-contacts-app.herokuapp.com/contacts/8882.json")
        let contactDetailviewModel = ContactDetailViewModel(model: contact)
        XCTAssert(contact == contactDetailviewModel.contact)
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func customEndpointClosure(_ target: API) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, target.testSampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
}
extension API {
    var testSampleData: Data {
        switch self {
        case .GETCONTACTS:
            // Returning contacts.json
            let url = Bundle(for: Gojek_DemoTests.self).url(forResource: "contacts", withExtension: "json")!
            let mockData = try? Data(contentsOf: url)
            return  mockData ?? Data()
        default:
            break
        }
    }
}
