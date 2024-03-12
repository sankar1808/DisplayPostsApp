//
//  ViewController.swift
//  TestApp
//
//  Created by Sankaranarayana Settyvari on 12/03/24.
//

import UIKit

struct Page: Codable {
    let page: Int
    let per_page: Int
    let total: Int
    let total_pages: Int
    let data: [PerPage]
}

struct PerPage: Codable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var postsTableview: UITableView!

    var posts = [PerPage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.postsTableview.delegate = self
        self.postsTableview.dataSource = self
        fetchApi()
    }

    func fetchApi() {
        let url = URL(string: "https://reqres.in/api/users?page=1")
        
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
                    do {
                        if let postData = data {
                            let decodedData = try JSONDecoder().decode(Page.self, from: postData)
                            DispatchQueue.main.async {
                                self.posts = decodedData.data
                                self.postsTableview.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "cell")
                                self.postsTableview.reloadData()
                            }
                        } else {
                            print("No data")
                        }
                    } catch {
                        print(error)
                    }
                }.resume()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PostCell = (self.postsTableview.dequeueReusableCell(withIdentifier: "cell") as? PostCell)!
        
        let post: PerPage = posts[indexPath.row] as PerPage
        cell.idLabel.text = String(post.id)
        cell.firstNameLabel.text = String(post.first_name)
        cell.lastNameLabel.text = String(post.last_name)
        cell.emailLabel.text = String(post.email)
        cell.postImageView.imageFromServerURL(urlString: post.avatar)
        
        return cell
    }
}

extension UIImageView {

 public func imageFromServerURL(urlString: String) {

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }}

