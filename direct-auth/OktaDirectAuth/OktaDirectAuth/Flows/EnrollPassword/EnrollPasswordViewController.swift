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

protocol EnrollPasswordViewControllerDelegate: AnyObject {
    func enroll(from controller: SigninController, password: String)
}

class EnrollPasswordViewController: UIViewController, SigninController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var nextButton: UIButton!

    var auth: OktaIdxAuth?
    var status: OktaIdxAuth.Status?
    var response: OktaIdxAuth.Response?
    
    weak var delegate: EnrollPasswordViewControllerDelegate?

    @IBAction private func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        guard let password = passwordField.text,
              !password.isEmpty
        else
        {
            return
        }
        
        delegate?.enroll(from: self, password: password)
    }
}
