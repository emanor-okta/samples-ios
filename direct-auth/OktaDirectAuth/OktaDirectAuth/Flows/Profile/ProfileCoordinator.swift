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
import OktaIdx

class ProfileCoordinator: WorkflowCoordinator {
    
    lazy var viewController: UIViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let rootViewController = storyboard.instantiateViewController(identifier: "ProfileTab") as? UITabBarController,
              let profileNavigationController = rootViewController.viewControllers?.first as? UINavigationController,
              var topViewController = profileNavigationController.topViewController as? ProfileTableViewController
        else {
            fatalError("View Controller must exist")
        }
        
        topViewController.delegate = self
        
        return rootViewController
    }()
    
    private(set) var currentUser: User?
    
    init(currentUser: User?) {
        self.currentUser = currentUser
    }
}

extension ProfileCoordinator: ProfileTableViewControllerDelegate {
    func onUserUpdate(_ completion: @escaping (User) -> Void) {
        NotificationCenter.default.addObserver(forName: .authenticationSuccessful,
                                               object: nil,
                                               queue: .main) { (notification) in
            guard let user = notification.object as? User else { return }
            self.currentUser = user
            
            DispatchQueue.main.async {
                completion(user)
            }
        }
    }
}
