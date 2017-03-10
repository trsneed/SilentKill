//: Playground - noun: a place where people can play

import UIKit
let baseUrl = URL(string: "https://silentkill-staging.herokuapp.com/")


    let m = URL(string: "auth/sign_in?email=antonwestman%40gmail.com&password=testfest", relativeTo: baseUrl)!
print(m.absoluteString)

