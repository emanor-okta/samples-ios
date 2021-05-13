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
import AuthenticationServices

final class LandingCoordinator: WorkflowCoordinator {
    lazy var viewController: UIViewController = {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        
        guard let rootViewController = storyboard.instantiateInitialViewController() as? UINavigationController,
              var topViewController = rootViewController.topViewController as? LandingViewController
        else {
            fatalError("View Controller must exist")
        }
        
        topViewController.delegate = self
        
        return rootViewController
    }()
    
    private let auth: OktaIdxAuth
    
    init(auth: OktaIdxAuth) {
        self.auth = auth
    }
}

extension LandingCoordinator: LandingViewControllerDelegate {
    func show(workflow: OnboardingViewType) {
        OnboardingManager.shared?.showWorkflow(workflow)
    }
    
    func performSocialAuth(from controller: UIViewController & SigninController & ASWebAuthenticationPresentationContextProviding) {
        auth.socialAuth(with: OktaIdxAuth.SocialOptions(presentationContext: controller, prefersEphemeralSession: false)) { (response, error) in
            if let error = error {
                controller.show(error: error)
            }
        }
    }
}
