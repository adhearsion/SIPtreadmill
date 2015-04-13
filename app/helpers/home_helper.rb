module HomeHelper
  def get_completed_test_runs
    complete = TestRun.accessible_by(current_ability).where(state: "complete")
    [
      {
        key: "Completed Successfully",
        values: complete.group("date(completed_at)").count(:id).to_a
      }
    ].to_json
  end
end
