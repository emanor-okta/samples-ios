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

protocol WorkflowCoordinator: AnyObject {
    var viewController: UIViewController { get }
}

final class AuthenticateCoordinator: WorkflowCoordinator {
    private let auth: OktaIdxAuth
    
    private var changePasswordCoordinator: NewPasswordCoordinator?
    
    lazy var viewController: UIViewController = {
        let storyboard = UIStoryboard(name: "Authenticate", bundle: nil)
        
        guard let rootViewController = storyboard.instantiateInitialViewController() as? UINavigationController,
              let topViewController = rootViewController.topViewController as? AuthenticateViewController
        else {
            fatalError("View Controller must exist")
        }
        
        topViewController.delegate = self
        
        return rootViewController
    }()
    
    init(auth: OktaIdxAuth) {
        self.auth = auth
    }
    
    private func handle(from viewController: UIViewController & SigninController,response: OktaIdxAuth.Response) {
        switch response.status {
        case .success: break
        case .passwordInvalid: break
        case .passwordExpired:
            changePasswordCoordinator = NewPasswordCoordinator(response: response)
            guard let controller = changePasswordCoordinator?.viewController else {
                return
            }
            
            viewController.navigationController?.pushViewController(controller, animated: true)
        case .tokenRevoked: break
        case .enrollAuthenticator: break
        case .verifyAuthenticator: break
        case .unknown: break
        case .operationUnavailable: break
        }
    }
    
}

extension AuthenticateCoordinator: AuthenticateViewControllerDelegate {
    func authenticate(from controller: UIViewController & SigninController, username: String, password: String) {
        auth.authenticate(username: username, password: password) { (response, error) in
            guard let response = response else {
                controller.show(error: error ?? OnboardingError.missingResponse)
                return
            }
            
            self.handle(from: controller, response: response)
        }
    }
}
