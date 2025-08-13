# advanced_data_processor.rb

class AdvancedDataProcessor
  # 高階関数的な手法でデータを処理するクラス

  def initialize(data)
    @data = data
  end

  # データに対する処理をチェーンのように実行する
  # filter, transform, aggregateはProcオブジェクトまたはブロックを期待する
  def process_data(filter_proc: nil, transform_proc: nil, aggregate_proc: nil)
    # フィルタリング
    filtered_data = filter_proc ? @data.select(&filter_proc) : @data

    # 変換
    transformed_data = transform_proc ? filtered_data.map(&transform_proc) : filtered_data

    # 集計
    if aggregate_proc
      transformed_data.reduce(&aggregate_proc)
    else
      transformed_data
    end
  end
end

# --- 実行例 ---

# 元のデータ
scores = [
  { name: "Alice", score: 85, passed: true },
  { name: "Bob", score: 92, passed: true },
  { name: "Charlie", score: 78, passed: false },
  { name: "David", score: 65, passed: false },
  { name: "Eve", score: 95, passed: true }
]

processor = AdvancedDataProcessor.new(scores)

# --- パターン1: 合格者のみの平均スコアを計算 ---

# 合格者をフィルタリングするProc
filter_passed = Proc.new { |student| student[:passed] }

# スコアのみを抽出するProc
extract_score = Proc.new { |student| student[:score] }

# 平均スコアを計算するProc
average_score = Proc.new { |sum, score| sum + score / 3.0 } # 合格者が3人いる前提

# もっと一般的な集計（合計値を計算）
sum_scores = Proc.new { |sum, score| sum + score }
sum_of_passed_scores = processor.process_data(
  filter_proc: filter_passed,
  transform_proc: extract_score,
  aggregate_proc: sum_scores
)
average_of_passed_scores = sum_of_passed_scores.to_f / scores.count { |s| s[:passed] }

puts "パターン1: 合格者の平均スコアを計算"
puts "合計スコア: #{sum_of_passed_scores}"
puts "平均スコア: #{average_of_passed_scores.round(2)}"
puts "---"

# --- パターン2: 不合格者の名前を大文字に変換 ---

# 不合格者をフィルタリングするブロック
filtered_names = processor.process_data(
  filter_proc: ->(student) { !student[:passed] },
  transform_proc: ->(student) { student[:name].upcase }
)

puts "パターン2: 不合格者の名前を大文字に変換"
puts "不合格者の名前: #{filtered_names.join(', ')}"
puts "---"

# --- パターン3: 全員のスコアを10点加算したリストを作成 ---

# 全員のスコアを10点加算
scores_plus_10 = processor.process_data(
  transform_proc: ->(student) { student.merge(score: student[:score] + 10) }
)

puts "パターン3: 全員のスコアを10点加算したリスト"
scores_plus_10.each do |student|
  puts "#{student[:name]}: #{student[:score]}"
end
