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

protocol RegisterViewControllerDelegate: AnyObject {
    func register(from controller: UIViewController & SigninController, firstName: String, lastName: String, email: String)
}

class RegisterViewController: UIViewController, SigninController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var firstnameField: UITextField!
    @IBOutlet private weak var lastnameField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var nextButton: UIButton!

    var auth: OktaIdxAuth?
    var response: OktaIdxAuth.Response?

    weak var delegate: RegisterViewControllerDelegate?
    
    @IBAction private func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction private func nextAction(_ sender: Any) {
        guard let firstname = firstnameField.text, !firstname.isEmpty,
              let lastname = lastnameField.text, !lastname.isEmpty,
              let email = emailField.text, !email.isEmpty
        else {
            return
        }
        
        delegate?.register(from: self, firstName: firstname, lastName: lastname, email: email)
    }
}
