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
//  CheckValidityVC.swift
//  DGCAWallet
//  
//  Created by Alexandr Chernyy on 08.07.2021.
//  
        

import UIKit
import SwiftDGC

final class CheckValidityVC: UIViewController {

  private enum Constants {
    static let titleCellIndentifier = "CellWithTitleAndDescriptionTVC"
    static let countryCellIndentifier = "CellWithDateAndCountryTVC"
    static let bottomOffset: CGFloat = 32.0
  }  
  @IBOutlet private weak var closeButton: UIButton!
  @IBOutlet private weak var checkValidityButton: UIButton!
  @IBOutlet private weak var tableView: UITableView!
  private var items: [ValidityCellModel] = []
  private var hCert: HCert?
  private var selectedDate = Date()
  private var selectedCountryCode: String?
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    checkValidityButton.setTitle(l10n("button_i_agree"), for: .normal)
  }
  @IBAction func closeButtonAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  private func setupView() {
    setupInitialDate()
    setupTableView()
    tableView.reloadData()
  }
  private func setupTableView() {
    tableView.dataSource = self
    tableView.register(UINib(nibName: Constants.titleCellIndentifier, bundle: nil),
                       forCellReuseIdentifier: Constants.titleCellIndentifier)
    tableView.register(UINib(nibName: Constants.countryCellIndentifier, bundle: nil),
                       forCellReuseIdentifier: Constants.countryCellIndentifier)
    tableView.contentInset = .init(top: .zero, left: .zero, bottom: Constants.bottomOffset, right: .zero)

  }
  private func setupInitialDate() {
    items.append(ValidityCellModel(title: l10n("country_certificate_text"),
                                   description: "",
                                   needChangeTitleFont: true))
    items.append(ValidityCellModel(cellType: .countryAndTimeSelection))
    items.append(ValidityCellModel(title: l10n("disclaimer"), description: l10n("disclaimer_text")))
  }
  func setHCert(cert: HCert?) {
    self.hCert = cert
  }
  @IBAction func checkValidityAction(_ sender: Any) {
    let ruleValidationVC = RuleValidationResultVC.loadFromNib()
    ruleValidationVC.closeHandler = {
      self.closeButtonAction(self)
    }
    self.present(ruleValidationVC, animated: true) {
      guard let hCert = self.hCert else { return }
      ruleValidationVC.setupView(with: hCert, selectedDate: self.selectedDate)
    }
  }
}

extension CheckValidityVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item: ValidityCellModel = items[indexPath.row]
    if item.cellType == .titleAndDescription {
      let base = tableView.dequeueReusableCell(withIdentifier: Constants.titleCellIndentifier, for: indexPath)
      guard let cell = base as? CellWithTitleAndDescriptionTVC else {
        return base
      }
      cell.setupCell(with: item)
      return cell
    } else {
      let base = tableView.dequeueReusableCell(withIdentifier: Constants.countryCellIndentifier, for: indexPath)
      guard let cell = base as? CellWithDateAndCountryTVC else {
        return base
      }
      cell.countryHandler = { [weak self] countryCode in
        self?.hCert?.ruleCountryCode = countryCode
      }
      cell.dataHandler = {[weak self] date in
        self?.selectedDate = date
      }
      cell.setupView()
      return cell
    }
  }
}