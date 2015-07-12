class User < ActiveRecord::Base

  def get_query_info(params = nil)
    queries = []
    IO.foreach("solution_queries.log") do |line|
      queries << line.scan(/\d{4}-\d{2}-\d{2}[a-zA-Z]\d{2}:\d{2}:\d{2}.\d{6}/).first.to_s[-8..-1].to_f
     end
    File.truncate("solution_queries.log", 0)
    queries.last - queries.first
  end


end
