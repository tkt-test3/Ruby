# weather_api_client_mock.rb

class WeatherAPIClientMock
  # 外部の天気APIクライアントを模倣するクラス

  # 都市ごとのダミーデータ
  DUMMY_WEATHER_DATA = {
    "Tokyo" => {
      "city" => "Tokyo",
      "weather" => "Cloudy",
      "temperature" => "25°C",
      "humidity" => "70%"
    },
    "New York" => {
      "city" => "New York",
      "weather" => "Sunny",
      "temperature" => "28°C",
      "humidity" => "55%"
    },
    "London" => {
      "city" => "London",
      "weather" => "Rainy",
      "temperature" => "18°C",
      "humidity" => "85%"
    }
  }.freeze # データを変更不可にする

  # 指定された都市の天気情報を取得する（シミュレーション）
  def self.get_weather_for(city)
    # city名をキーとしてダミーデータを検索
    data = DUMMY_WEATHER_DATA[city]

    if data
      # データが見つかった場合は、APIからのJSONレスポンスを模倣してハッシュを返す
      puts "#{city}の天気情報を取得しました。（モック）"
      data
    else
      # データが見つからない場合は、エラーレスポンスを模倣
      puts "#{city}のデータは見つかりませんでした。（モック）"
      { "error" => "City not found" }
    end
  end

  # 受け取った天気データから天気と気温を抽出して表示する
  def self.display_weather_info(weather_data)
    if weather_data["error"]
      puts "エラー: #{weather_data["error"]}"
    else
      puts "--- 天気情報 ---"
      puts "都市: #{weather_data["city"]}"
      puts "天気: #{weather_data["weather"]}"
      puts "気温: #{weather_data["temperature"]}"
      puts "------------------"
    end
  end
end

# --- 実行例 ---

# 有効な都市の情報を取得
tokyo_weather = WeatherAPIClientMock.get_weather_for("Tokyo")
WeatherAPIClientMock.display_weather_info(tokyo_weather)

puts "" # 区切り

# 無効な都市の情報を取得
paris_weather = WeatherAPIClientMock.get_weather_for("Paris")
WeatherAPIClientMock.display_weather_info(paris_weather)
