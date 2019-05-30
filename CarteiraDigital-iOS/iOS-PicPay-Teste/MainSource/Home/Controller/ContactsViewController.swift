//
//  ViewController.swift
//  iOS-PicPay-Teste
//
//  Created by Mac Novo on 03/12/18.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    deinit {
        print("Removeu referência")
    }
    
    //Replace the color of next viewcontroller and change he's color to green
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeBackLabelAndChangeColor(with: .lightGreen)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    let viewModel = ContatosListaViewModel()
    
    //Constants
    var searchBar: SearchBarView = {
        let search = SearchBarView()
        search.textField.addTarget(self, action: #selector(handlerChangedValue(_:)), for: .editingChanged)
        search.sizeToFit()
        return search
    }()
    
    var searchBarOnTop: SearchBarView = {
        let search = SearchBarView()
        search.textField.addTarget(self, action: #selector(handlerChangedValue(_:)), for: .editingChanged)
        search.sizeToFit()
        return search
    }()
    
    var titleViewc: CustomNavView = {
        let view = CustomNavView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTopSearchBar()
        configureSearchDelegate()
        configureTableView()
        configureSelections()
        fetchContacts()
        self.customAlert()
        
        guard let _ = UserDefaults.standard.value(forKey: WalletKeysUser.private_key) else {
            self.navigationController?.pushViewController(PrimingController(), animated: true)
            return
        }
    }
    
    var tableView: UITableView = {
        let table = UITableView(frame: CGRect(), style: .grouped)
        table.backgroundColor = .clear
        return table
    }()
    
    //MARK:- Download Main Contacts
    @objc fileprivate func fetchContacts() {
        
//        self.viewModel.handleRequest { [weak self] (error, success)  in
//            if let error = error?.localizedDescription {
//                Alert.showAlertWithTryAgain(title: "Erro", text: error, context: self, completion: {
//                    self?.fetchContacts()
//                })
//            }
//            self?.tableView.reloadData()
//            self?.tableView.refreshControl?.endRefreshing()
//        }
    }
    
    
    
    fileprivate func customAlert() {
        let customAlet = NewsFriendsAletView()
        customAlet.text = "Pague alguém com a UCL Coin. Escanei o QRCode ou procure na sua lista de contatos."
        self.view.addSubview(customAlet)
        let size = self.view.frame.size
        customAlet.transform = CGAffineTransform(scaleX: 0, y: 0)
        customAlet.centerInSuperview(size: CGSize(width: (size.width) * 0.8, height: (size.width) * 0.7))
        UIView.animate(withDuration: 0.1, delay: 0.2, options: .curveEaseInOut, animations: {
            customAlet.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
        self.searchBar.actionQRCode = { [weak self] in
            
        }
        
    }
    
    //MARK:- Configuration of ViewController
    fileprivate func configureTableView() {
        self.navigationItem.titleView = UIView()
        self.view.backgroundColor = .strongBlack
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.hidesSearchBarWhenScrolling = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barTintColor = .strongBlack
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    
    fileprivate func configureViewController() {
        self.view.addSubview(self.titleViewc)
        self.view.addSubview(self.tableView)
        self.tableView.fillSuperview()
        self.tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        self.tableView.register(MainListContactsCell.self, forCellReuseIdentifier: MainListContactsCell.cellId)
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        
//        let rc = UIRefreshControl()
//        rc.tintColor = .white
//        rc.addTarget(self, action: #selector(fetchContacts), for: .valueChanged)
//        self.tableView.refreshControl = rc
    }
    
    //MARK:- Selections
    fileprivate func configureSelections() {
        self.viewModel.didSelect = { [weak self] contato in
            self?.pushViewController(contato)
        }
        
        ControlNewPayment.callTicketView = { [weak self] (ticket) in
            let viewc = CheckingViewController()
            viewc.ticket = ticket
            viewc.modalPresentationStyle = .overFullScreen
            self?.present(viewc, animated: true, completion: nil)
        }
    }
    
    //Concigure the static searchbar on top
    fileprivate func configureTopSearchBar() {
        self.view.addSubview(self.searchBarOnTop)
        self.searchBarOnTop.anchor(top: self.view.layoutMarginsGuide.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(), size: .init(width: self.view.frame.width, height: 60))
        
        
        guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
            return
        }
        statusBarView.backgroundColor = UIColor.strongBlack
    }
    
    
    //MARK:- Handlers
    //Custom SearchBar valueChanged
    @objc fileprivate func handlerChangedValue(_ textField: UITextField) {
        let str = textField.text!
        filterContentForSearchText(str)
    }    
    
    //MARK:- Change Direction Controller
    fileprivate func pushViewController(_ contato: Contato) {
        let cred = CredCoreData()
        if cred.FetchRequest()?.numero != nil {
            let viewc = PaymentViewController()
            viewc.contato = contato
            self.navigationController?.pushViewController(viewc, animated: true)
        } else {
            let viewc = PrimingController()
            viewc.contato = contato
            self.navigationController?.pushViewController(viewc, animated: true)
        }
    }
    
    //MARK:- TableView Functions
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MainListContactsCell.cellId, for: indexPath) as? MainListContactsCell {
            cell.item = self.viewModel.cellForRow(with: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.didSelectRow(with: indexPath.row)
    }
    
    
    // MARK: - UISearchResultsUpdating Delegate
    internal func configureSearchDelegate() {
        self.searchBar.textField.delegate = self
        searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 55)
        definesPresentationContext = true
    }
    
    
    // MARK: - Private instance methods
    fileprivate func filterContentForSearchText(_ searchText: String) {
        self.viewModel.items = self.viewModel.filtered.filter({( contato : Contato) -> Bool in
            if searchText == "" {
                self.viewModel.items = self.viewModel.filtered
                return true
            } else {
                return true && (contato.name.lowercased().contains(searchText.lowercased()))
            }
        })
        self.tableView.reloadData()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchBar.isEditing = true
        self.searchBarOnTop.isEditing = true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.searchBar.isEditing = false
        self.searchBarOnTop.isEditing = false
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if(offset > 17.0) {
            hiddenTopNavbar(by: false)
        } else {
            hiddenTopNavbar(by: true)
        }
        
        if(offset > 200){
            self.titleViewc.frame = CGRect(x: 20, y: 0, width: self.view.bounds.size.width, height: 0)
        } else {
            self.titleViewc.frame = CGRect(x: 20, y: 0, width: self.view.bounds.size.width, height: 95 - offset)
        }
    }
    
    
    
    fileprivate func hiddenTopNavbar(by bool: Bool) {
        if self.searchBarOnTop.isHidden, bool {
            self.searchBarOnTop.isHidden = bool
            self.searchBarOnTop.textField.text = self.searchBar.textField.text
        } else {
            self.searchBarOnTop.isHidden = bool
            self.searchBar.textField.text = self.searchBarOnTop.textField.text
        }
    }
}

extension ContactsViewController: ProtocolQrCodeCatch {
    func didGetDataProtocol(_ string: String) {
        print(string)
    }
}
