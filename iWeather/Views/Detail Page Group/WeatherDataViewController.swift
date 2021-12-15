//
//  WeatherDataViewController.swift
//  iWeather
//
//  Created by Tianxu Lan on 11/19/21.
//

import UIKit
import Highcharts
class WeatherDataViewController: UIViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var precipitationValue: UILabel!
    @IBOutlet weak var humidityValue: UILabel!
    @IBOutlet weak var cloudCoverValue: UILabel!
    var city: String!
    var chartData:[Any] = []
    var chartView: HIChartView!
    @IBOutlet weak var navigation: UINavigationItem!
    var weatherDataWeather = CurrentWeatherModel(temperature: "", status: "", humidity: "", windSpeed: "", visibility: "", pressure: "", precipitationProbability: "", cloudCover: "", UVIndex: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.title = city
        titleView.layer.borderColor = UIColor.white.cgColor
        refreshPage()
        drawChart()
    }
    func refreshPage()
    {
        
        print(weatherDataWeather)
        self.precipitationValue.text = self.weatherDataWeather.getPrecipitationProbabilityText()
        self.humidityValue.text = self.weatherDataWeather.getHumidityText()
        self.cloudCoverValue.text = self.weatherDataWeather.getCloudCoverText()
    }
    // Attention: the drawChart function is modified from Highchart official demo https://www.highcharts.com/demo/ios/gauge-activity
    func drawChart()
    {
        chartView = HIChartView(frame: CGRect(x: 0, y: K.chartYCoordinate, width: K.screenWidth, height: K.chartHeight))
        chartView.plugins = ["solid-gauge"]

            let options = HIOptions()

            let chart = HIChart()
            chart.type = "solidgauge"
            chart.height = "100%"
            options.chart = chart

            let title = HITitle()
            title.text = "Weather Data"
            title.style = HICSSObject()
            title.style.fontSize = "20px"
            options.title = title

            //tooltip
            let tooltip = HITooltip()
            tooltip.borderWidth = 0
            tooltip.shadow = HIShadowOptionsObject()
        
            tooltip.shadow.opacity = 0
            tooltip.style = HICSSObject()
            tooltip.style.fontSize = "16px"
            tooltip.valueSuffix = "%"
            tooltip.pointFormat = "{series.name}<br><span style=\"font-size:2em; color: {point.color}; font-weight: bold\">{point.y}</span>"
            tooltip.positioner = HIFunction(jsFunction: "function (labelWidth) { return { x: (this.chart.chartWidth - labelWidth) / 2, y: (this.chart.plotHeight / 2) + 10 }; }")
        tooltip.backgroundColor = HIColor(name: "transparent")
        
            options.tooltip = tooltip

            let pane = HIPane()
            pane.startAngle = 0
            pane.endAngle = 360

            //cloudCover Background
            let background1 = HIBackground()
        background1.backgroundColor = HIColor(rgba: 137, green: 208, blue: 63, alpha: 0.35)
            background1.outerRadius = "112%"
            background1.innerRadius = "88%"
            background1.borderWidth = 0

            //Precipitation Background
            let background2 = HIBackground()
            background2.backgroundColor = HIColor(rgba: 66, green: 161, blue: 245, alpha: 0.35)
            background2.outerRadius = "87%"
            background2.innerRadius = "63%"
            background2.borderWidth = 0

            //
            let background3 = HIBackground()
            background3.backgroundColor = HIColor(rgba: 228, green: 116, blue: 113, alpha: 0.35)
            background3.outerRadius = "62%"
            background3.innerRadius = "38%"
            background3.borderWidth = 0

            pane.background = [
              background1, background2, background3
            ]
        

            options.pane = pane

            // yaxis
        
            let yAxis = HIYAxis()
            yAxis.min = 0
            yAxis.max = 100
            yAxis.lineWidth = 0
        yAxis.visible = false
        
            options.yAxis = [yAxis]

            // plot options
            let plotOptions = HIPlotOptions()
            plotOptions.solidgauge = HISolidgauge()
            let dataLabels = HIDataLabels()
            dataLabels.enabled = false
        
            plotOptions.solidgauge.dataLabels = [dataLabels]
            plotOptions.solidgauge.linecap = "round"
            plotOptions.solidgauge.stickyTracking = false
            plotOptions.solidgauge.rounded = true
            options.plotOptions = plotOptions

        
            //Green Cloud Cover Data
            let move = HISolidgauge()
            move.name = "Cloud Cover"
            let moveData = HIData()
        moveData.color = HIColor(rgba: 137, green: 208, blue: 63, alpha:  1)
            moveData.radius = "112%"
            moveData.innerRadius = "88%"
        moveData.y = weatherDataWeather.getCloudCoverInt()
            move.data = [moveData]

            // Precipitation Data
            let exercise = HISolidgauge()
            exercise.name = "Precipitation"
            let exerciseData = HIData()
            exerciseData.color = HIColor(rgba: 66, green: 161, blue: 245, alpha: 1)
            exerciseData.radius = "87%"
            exerciseData.innerRadius = "63%"
        exerciseData.y = weatherDataWeather.getPrecipitationInt()
            exercise.data = [exerciseData]

            // Humidity Data
            let stand = HISolidgauge()
            stand.name = "Humidity"
            let standData = HIData()
            standData.color = HIColor(rgba: 228, green: 116, blue: 113, alpha: 1)
            standData.radius = "62%"
            standData.innerRadius = "38%"
        standData.y = weatherDataWeather.getHumidityInt()
            stand.data = [standData]

            options.series = [move, exercise, stand]

            chartView.options = options

            self.view.addSubview(chartView)
        
    }
    
   
    
    @IBAction func backButtonOnPressed(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func twitterButtonOnPressed(_ sender: Any) {
        let twitterText = "The current temperature at \(self.city!) is \(self.weatherDataWeather.getTemperatureText()). The weather conditions are \(self.weatherDataWeather.getStatusText()!)#CSCI571WeatherSearch"
        let EncodedTwitterText = twitterText.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
        guard let url = URL(string: "https://twitter.com/intent/tweet?text=" + EncodedTwitterText!) else { print("can't produce URL"); return }
        
        UIApplication.shared.open(url)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
