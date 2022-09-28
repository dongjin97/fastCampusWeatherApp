//
//  ViewController.swift
//  weatherApp
//
//  Created by 원동진 on 2022/09/27.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temLabel: UILabel!
    @IBOutlet weak var maxTemlabel: UILabel!
    @IBOutlet weak var minTemLabel: UILabel!
    @IBOutlet weak var weatherStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapGetWeather(_ sender: UIButton) {
        if let cityName = self.cityTextField.text{
            getCurrentWeather(cityName: cityName)
            self.view.endEditing(true)
        }
    }
    func configureView(model : WeatherInformation){
        self.cityName.text = model.name
        if let wearther = model.weather.first{
            self.weatherDescriptionLabel.text = wearther.description
        }
        self.temLabel.text = "\(Int(model.main.temp - 273.15))℃"
        self.maxTemlabel.text = "최저: \(Int(model.main.temp_max - 273.15))℃"
        self.minTemLabel.text = "최고: \(Int(model.main.temp_min - 273.15))℃"
    }
    func showAlert(message : String){
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
    //weak self - 순환 참조 문제 해결 을 위해 -> 더 자세히 알아보기
    func getCurrentWeather(cityName: String) {
      guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=0eabf515a04241b173c5596585ab7e0e") else { return }
      let session = URLSession(configuration: .default)
      session.dataTask(with: url) { [weak self] data, response, error in
        guard let data = data, error == nil else { return }
        let suseectStuatus = 200..<300
        let decoder = JSONDecoder()
          if let response = response as? HTTPURLResponse, suseectStuatus.contains(response.statusCode){
              guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
              DispatchQueue.main.async {
                  self?.weatherStackView.isHidden = false
                  self?.configureView(model: weatherInformation)
                  
              }
          }else {
              guard let errMessage = try? decoder.decode(ErrorMessage.self, from: data) else {return}
              print("\(errMessage.message)")
              DispatchQueue.main.async {
                  self?.showAlert(message: errMessage.message)
              }
          }
      }.resume()
    }
}

