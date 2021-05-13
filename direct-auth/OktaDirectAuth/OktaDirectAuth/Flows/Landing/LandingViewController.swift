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

import AuthenticationServices
import UIKit
import OktaIdxAuth

protocol SigninController {
    var auth: OktaIdxAuth? { get set }
    var response: OktaIdxAuth.Response? { get set }
    
    func show(error: Error)
}

extension SigninController where Self: UIViewController {
    func show(error: Error) {
        let alert = UIAlertController(title: nil,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "OK",
                              style: .default,
                              handler: { (action) in
            
        }))
        present(alert, animated: true)
    }
}

protocol LandingViewControllerDelegate: AnyObject {
    func show(workflow: OnboardingViewType)
    func performSocialAuth(from controller: UIViewController & SigninController & ASWebAuthenticationPresentationContextProviding)
}

class LandingViewController: UIViewController, SigninController {
    @IBOutlet weak private(set) var signInButtonStackView: UIStackView!
    @IBOutlet weak private(set) var registerButton: SigninButton!
    @IBOutlet weak private(set) var backgroundImageView: UIImageView!
    @IBOutlet weak private(set) var footerView: UIView!
    var auth: OktaIdxAuth?
    var response: OktaIdxAuth.Response?
    
    weak var delegate: LandingViewControllerDelegate?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction private func usernameAndPasswordSignIn() {
        delegate?.show(workflow: .usernameAndPassword)
    }
    
    @IBAction private func socialAuth() {
        delegate?.performSocialAuth(from: self)
    }
}

extension LandingViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        view.window ?? UIWindow()
    }
}
