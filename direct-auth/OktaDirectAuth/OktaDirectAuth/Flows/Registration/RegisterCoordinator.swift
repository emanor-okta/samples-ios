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

final class RegisterCoordinator: WorkflowCoordinator {
    lazy var viewController: UIViewController = {
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        
        guard let rootViewController = storyboard.instantiateInitialViewController() as? UINavigationController,
              let topViewController = rootViewController.topViewController as? RegisterViewController
        else {
            fatalError("View Controller must exist")
        }
        
        topViewController.delegate = self
        
        return rootViewController
    }()
    
    private let auth: OktaIdxAuth
    private var enrollPasswordCoordinator: EnrollPasswordCoordinator?
    
    init(auth: OktaIdxAuth) {
        self.auth = auth
    }
    
    private func handle(from viewController: UIViewController & SigninController, response: OktaIdxAuth.Response) {
        switch response.status {
        case .success: break
        case .passwordInvalid: break
        case .passwordExpired: break
        case .tokenRevoked: break
        case .enrollAuthenticator:
            guard response.availableAuthenticators.contains(.password) else {
                return
            }
            
            response.select(authenticator: .password) { (response, error) in
                guard let response = response else {
                    viewController.show(error: error ?? OnboardingError.missingResponse)
                    return
                }
                
                let enrollCoordinator = EnrollPasswordCoordinator(response: response)
                self.enrollPasswordCoordinator = enrollCoordinator
                
                viewController.navigationController?.pushViewController(enrollCoordinator.viewController, animated: true)
            }
        case .verifyAuthenticator: break
        case .unknown: break
        case .operationUnavailable: break
        }
    }
}

extension RegisterCoordinator: RegisterViewControllerDelegate {
    func register(from controller: UIViewController & SigninController, firstName: String, lastName: String, email: String) {
        auth.register(firstName: firstName,
                      lastName: lastName,
                      email: email) { (response, error) in
            guard let response = response else {
                controller.show(error: error ?? OnboardingError.missingResponse)
                return
            }
            
            self.handle(from: controller, response: response)
        }
    }
}
