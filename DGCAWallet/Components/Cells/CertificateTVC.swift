//
/*-
 * ---license-start
 * eu-digital-green-certificates / dgca-wallet-app-ios
 * ---
 * Copyright (C) 2021 T-Systems International GmbH and all other contributors
 * ---
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ---license-end
 */
//  
//  CertificateCell.swift
//  DGCAWallet
//  
//  Created by Alexandr Chernyy on 21.09.2021.
//
//  Updated by Igor Khomiak on 11.10.2021.
        

import UIKit
import SwiftDGC

class CertificateCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  private var hCert: HCert? {
    didSet {
      setupView()
    }
  }
      
  private func setupView() {
    if let hCert = hCert {
      nameLabel.text = hCert.fullName
      descriptionLabel.text = hCert.exp.dateString
    } else {
      nameLabel.text = ""
      descriptionLabel.text = ""
    }
  }

  public func setCertificate(cert: HCert) {
    hCert = cert
  }
  
  override func prepareForReuse() {
    hCert = nil
  }
}
