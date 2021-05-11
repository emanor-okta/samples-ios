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

protocol AuthenticateViewControllerDelegate {
    func authenticate(from: UIViewController, with username: String, password: String)
}

@IBDesignable
class AuthenticateViewController: UIViewController, SigninController {
    @IBOutlet weak private(set) var scrollView: UIScrollView!
    @IBOutlet weak private(set) var usernameField: UITextField!
    @IBOutlet weak private(set) var passwordField: UITextField!
    @IBOutlet weak private(set) var nextButton: UIButton!

    var auth: OktaIdxAuth?
    var response: OktaIdxAuth.Response?

    @IBAction private func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction private func nextAction(_ sender: Any) {
        guard let username = usernameField.text, username.count > 0,
              let password = passwordField.text, password.count > 0,
              let auth = auth
        else {
            return
        }
        
        auth.authenticate(username: username, password: password) { (response, error) in
            guard let response = response else {
                self.show(error: error ?? OnboardingError.missingResponse)
                return
            }
            
            self.handle(response: response)
        }
    }
        
    private func handle(response: OktaIdxAuth.Response) {
        switch response.status {
        case .success: break
        case .passwordInvalid: break
        case .passwordExpired:
            showController(for: response, with: "ChangePassword")
        case .tokenRevoked: break
        case .enrollAuthenticator: break
        case .verifyAuthenticator: break
        case .unknown: break
        case .operationUnavailable: break
        }
    }
}
