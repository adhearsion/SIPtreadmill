module HomeHelper
  def get_completed_test_runs
    graph_data = [{key: "Completed Successfully", values: []}]
    complete = TestRun.accessible_by(current_ability).where(state: "complete").group("date(completed_at)").count :id
    complete.each do |k,v|
      graph_data[0][:values] << [k, v]
    end
    graph_data.to_json
  end
end
