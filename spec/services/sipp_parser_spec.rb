require 'spec_helper'

describe SippParser do

  let(:csv_data) do
    <<-DATA
StartTime;LastResetTime;CurrentTime;ElapsedTime(P);ElapsedTime(C);TargetRate;CallRate(P);CallRate(C);IncomingCall(P);IncomingCall(C);OutgoingCall(P);OutgoingCall(C);TotalCallCreated;CurrentCall;SuccessfulCall(P);SuccessfulCall(C);FailedCall(P);FailedCall(C);FailedCannotSendMessage(P);FailedCannotSendMessage(C);FailedMaxUDPRetrans(P);FailedMaxUDPRetrans(C);FailedTcpConnect(P);FailedTcpConnect(C);FailedTcpClosed(P);FailedTcpClosed(C);FailedUnexpectedMessage(P);FailedUnexpectedMessage(C);FailedCallRejected(P);FailedCallRejected(C);FailedCmdNotSent(P);FailedCmdNotSent(C);FailedRegexpDoesntMatch(P);FailedRegexpDoesntMatch(C);FailedRegexpShouldntMatch(P);FailedRegexpShouldntMatch(C);FailedRegexpHdrNotFound(P);FailedRegexpHdrNotFound(C);FailedOutboundCongestion(P);FailedOutboundCongestion(C);FailedTimeoutOnRecv(P);FailedTimeoutOnRecv(C);FailedTimeoutOnSend(P);FailedTimeoutOnSend(C);OutOfCallMsgs(P);OutOfCallMsgs(C);DeadCallMsgs(P);DeadCallMsgs(C);Retransmissions(P);Retransmissions(C);AutoAnswered(P);AutoAnswered(C);Warnings(P);Warnings(C);FatalErrors(P);FatalErrors(C);WatchdogMajor(P);WatchdogMajor(C);WatchdogMinor(P);WatchdogMinor(C);ResponseTime1(P);ResponseTime1(C);ResponseTime1StDev(P);ResponseTime1StDev(C);CallLength(P);CallLength(C);CallLengthStDev(P);CallLengthStDev(C);ResponseTimeRepartition1;ResponseTimeRepartition1_<10;ResponseTimeRepartition1_<20;ResponseTimeRepartition1_<30;ResponseTimeRepartition1_<40;ResponseTimeRepartition1_<50;ResponseTimeRepartition1_<100;ResponseTimeRepartition1_<150;ResponseTimeRepartition1_<200;ResponseTimeRepartition1_>=200;CallLengthRepartition;CallLengthRepartition_<10;CallLengthRepartition_<50;CallLengthRepartition_<100;CallLengthRepartition_<500;CallLengthRepartition_<1000;CallLengthRepartition_<5000;CallLengthRepartition_<10000;CallLengthRepartition_>=10000;
2013-08-15  14:27:26:997  1376569646.997987;2013-08-15  14:27:26:997  1376569646.997987;2013-08-15  14:27:27:000  1376569647.000370;00:00:00;00:00:00;2;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;00:00:00:000;00:00:00:000;00:00:00:000;00:00:00:000;00:00:00:000;00:00:00:000;00:00:00:000;00:00:00:000;;0;0;0;0;0;0;0;0;0;;0;0;0;0;0;0;0;0;
2013-08-15  14:27:26:997  1376569646.997987;2013-08-15  14:27:27:000  1376569647.000488;2013-08-15  14:27:37:000  1376569657.000683;00:00:10;00:00:10;2;2;1.9996;0;0;20;20;20;1;19;19;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;00:00:00:000;00:00:00:000;00:00:00:000;00:00:00:000;00:00:00:002;00:00:00:002;00:00:00:001;00:00:00:001;;20;0;0;0;0;0;0;0;0;;19;0;0;0;0;0;0;0;
2013-08-15  14:27:26:997  1376569646.997987;2013-08-15  14:27:37:000  1376569657.000729;2013-08-15  14:27:47:002  1376569667.002686;00:00:10;00:00:20;2;1.9998;1.9996;0;0;20;40;40;1;20;39;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;00:00:00:000;00:00:00:000;00:00:00:000;00:00:00:000;00:00:00:001;00:00:00:001;00:00:00:000;00:00:00:001;;40;0;0;0;0;0;0;0;0;;39;0;0;0;0;0;0;0;
2013-08-15  14:27:26:997  1376569646.997987;2013-08-15  14:27:47:002  1376569667.002734;2013-08-15  14:27:52:003  1376569672.003940;00:00:05;00:00:25;2;1.9996;1.9996;0;0;10;50;50;0;11;50;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;00:00:00:000;00:00:00:000;00:00:00:000;00:00:00:000;00:00:00:002;00:00:00:002;00:00:00:000;00:00:00:001;;50;0;0;0;0;0;0;0;0;;50;0;0;0;0;0;0;0;
2013-08-15  14:27:26:997  1376569646.997987;2013-08-15  14:27:52:003  1376569672.003985;2013-08-15  14:27:52:004  1376569672.004030;00:00:00;00:00:25;2;0;1.99952;0;0;0;50;50;0;0;50;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;00:00:00:000;00:00:00:000;00:00:00:000;00:00:00:000;00:00:00:000;00:00:00:002;00:00:00:000;00:00:00:001;;50;0;0;0;0;0;0;0;0;;50;0;0;0;0;0;0;0;
    DATA
  end

  let(:test_run) { FactoryGirl.create :test_run }

  subject { SippParser.new(csv_data, test_run) }

  it "parses the file and adds results to test run" do
    subject.run
    test_run.reload

    test_run.sipp_data.size.should == 5

    first_result = test_run.sipp_data.first
    first_result[:time].should == Time.new(2000, 1, 1, 14, 27, 27, "+00:00")
    first_result[:total_calls].should == 0
    first_result[:successful_calls].should == 0
    first_result[:failed_calls].should == 0
    first_result[:concurrent_calls].should == 0
    first_result[:avg_call_duration].should == 0
    first_result[:response_time].should == '00:00:00:000'
    first_result[:cps].should == 0
  end
end
