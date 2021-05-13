/*
 * Copyright (c) 2021, Okta, Inc. and/or its affiliates. All rights reserved.
 * The Okta software accompanied by this notice is provided pursuant to the Apache License, Version 2.0 (the "License.")
 *
 * You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and limitations under the License.
 */

import UIKit
import OktaIdxAuth

final class EnrollPasswordCoordinator: WorkflowCoordinator {
    private let response: OktaIdxAuth.Response
    
    lazy var viewController: UIViewController = {
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(identifier: "EnrollPassword") as? EnrollPasswordViewController else {
            fatalError("View Controller must exist")
        }
        
        viewController.delegate = self
        
        return viewController
    }()
    
    init(response: OktaIdxAuth.Response) {
        self.response = response
    }
    
    private func handle(from controller: SigninController, response: OktaIdxAuth.Response) {
        switch response.status {
        case .success: break
        case .tokenRevoked: break
        case .passwordInvalid: break
        case .passwordExpired: break
        case .enrollAuthenticator:
            if response.availableAuthenticators.contains(.skip) {
                response.select(authenticator: .skip) { (response, error) in
                    guard let _ = response else {
                        controller.show(error: error ?? OnboardingError.missingResponse)
                        return
                    }

                }
            }
        case .verifyAuthenticator: break
        case .unknown: break
        case .operationUnavailable: break
        }
    }
}

extension EnrollPasswordCoordinator: EnrollPasswordViewControllerDelegate {
    func enroll(from controller: SigninController, password: String) {
        guard let authenticator = response.authenticator as? OktaIdxAuth.Authenticator.Password else {
            return
        }
        
        authenticator.enroll(password: password) { (response, error) in
            guard let response = response else {
                controller.show(error: error ?? OnboardingError.missingResponse)
                return
            }

            self.handle(from: controller, response: response)
        }
    }
}
