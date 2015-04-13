# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

main_scenario = Scenario.find_or_create_by_name_and_sipp_xml 'My First Scenario', <<-XML
<?xml version="1.0" encoding="ISO-8859-1" ?>
<!DOCTYPE scenario SYSTEM "sipp.dtd">

<!-- Contact Jin Tang for support, jt2443@att.com -->

<scenario name="Reg_Call_A">
  <send>
    <![CDATA[

      INVITE sip:[field2]@sink.local.treadmill.mojolingo.net SIP/2.0
      Call-ID: [call_id]
      CSeq: 1 INVITE
      From: <sip:[field0]@sink.local.treadmill.mojolingo.net>;tag=[call_number]
      To: <sip:[field2]@sink.local.treadmill.mojolingo.net>
      Via: SIP/2.0/[transport] [local_ip]:[local_port];branch=[branch]
      Max-Forwards: 20
      Content-Type: application/sdp
      Contact: "[field0]" <sip:[field0]@[local_ip]:[local_port]>
      User-Agent: SIPp-Client
      Content-Length:[len]

      v=0
      o=[field0] 3216549878 3216549878 IN IP[local_ip_type] [local_ip]
      s=A SIPp Fan
      t=0 0
      c=IN IP[media_ip_type] [media_ip]
      m=audio [media_port] RTP/AVP 0 8 14 101
      a=rtpmap:0 PCMU/8000
      a=rtpmap:8 PCMA/8000
      a=rtpmap:14 MPA/8000
      a=rtpmap:101 telephone-event/8000

    ]]>
  </send>

  <recv response="100" optional="true">
  </recv>

  <recv response="200">
  </recv>

  <send>
    <![CDATA[

      ACK [$contact_remote] SIP/2.0
      Call-ID: [call_id]
      CSeq: 1 ACK
      Via: SIP/2.0/[transport] [local_ip]:[local_port];branch=[branch]
      From: <sip:[field0]@sink.local.treadmill.mojolingo.net>;tag=[call_number]
      To: <sip:[field2]@sink.local.treadmill.mojolingo.net>[peer_tag_param]
      Max-Forwards: 70
      User-Agent: SIPp-Client
      Content-Length: 0

    ]]>
  </send>


  <pause milliseconds="5000"/>


  <send>
    <![CDATA[

      BYE [$contact_remote] SIP/2.0
      Via: SIP/2.0/[transport] [local_ip]:[local_port];branch=[branch]
      Call-ID: [call_id]
      From: <sip:[field0]@sink.local.treadmill.mojolingo.net>;tag=[call_number]
      To: <sip:[field2]@sink.local.treadmill.mojolingo.net>[peer_tag_param]
      Max-Forwards: 70
      CSeq: 2 BYE
      User-Agent: SIPp-Client
      Content-Length: 0

    ]]>
  </send>

  <recv response="200" crlf="true">
  </recv>


  <ResponseTimeRepartition value="10, 20, 30, 40, 50, 100, 150, 200"/>
  <CallLengthRepartition value="10, 50, 100, 500, 1000, 5000, 10000"/>
</scenario>
XML

registration_scenario = Scenario.find_or_create_by_name_and_receiver_and_sipp_xml 'My First Registration Scenario', true, <<-XML
<?xml version="1.0" encoding="ISO-8859-1" ?>
<!DOCTYPE scenario SYSTEM "sipp.dtd">

<!-- Contact Jin Tang for support, jt2443@att.com -->

<scenario name="Registration">
  <send retrans="500">
    <![CDATA[

      REGISTER sip:sink.local.treadmill.mojolingo.net SIP/2.0
      Via: SIP/2.0/[transport] [local_ip]:[local_port];branch=[branch]
      From: "[field0]" <sip:[field0]@sink.local.treadmill.mojolingo.net>;tag=[call_number]
      To: "[field0]" <sip:[field0]@sink.local.treadmill.mojolingo.net>
      Call-ID: [call_id]
      CSeq: 1 REGISTER
      Contact: sip:[field0]@[local_ip]:[local_port]
      Max-Forwards: 20
      Expires: 3600
      Authorization: Digest username="[field0]@sink.local.treadmill.mojolingo.net",realm="sink.local.treadmill.mojolingo.net",nonce="",response="",uri="sip:sink.local.treadmill.mojolingo.net"
      User-Agent: SIPp-Client
      Content-Length: 0

    ]]>
  </send>

  <recv response="401" auth="true">
  </rev>

  <send retrans="500">
    <![CDATA[

      REGISTER sip:sink.local.treadmill.mojolingo.net SIP/2.0
      Via: SIP/2.0/[transport] [local_ip]:[local_port];branch=[branch]
      From: "[field0]" <sip:[field0]@sink.local.treadmill.mojolingo.net>;tag=[call_number]
      To: "[field0]" <sip:[field0]@sink.local.treadmill.mojolingo.net>
      Call-ID: [call_id]
      CSeq: 2 REGISTER
      Contact: sip:[field0]@[local_ip]:[local_port]
      Max-Forwards: 20
      Expires: 3600
      [field1]
      User-Agent: SIPp-Client
      Content-Length: 0

    ]]>
  </send>

  <recv response="200">
  </recv>

  <ResponseTimeRepartition value="10, 20, 30, 40, 50, 100, 150, 200"/>
  <CallLengthRepartition value="10, 50, 100, 500, 1000, 5000, 10000"/>
</scenario>
XML

receiver_scenario = Scenario.find_or_create_by_name_and_receiver_and_sipp_xml 'My First Receiver Scenario', true, <<-XML
<?xml version="1.0" encoding="ISO-8859-1" ?>
<!DOCTYPE scenario SYSTEM "sipp.dtd">

<!-- Contact Jin Tang for support, jt2443@att.com -->

<scenario name="uas_ims">

  <recv request="INVITE" crlf="true">
  </recv>

  <send>
    <![CDATA[

      SIP/2.0 180 Ringing
      [last_Call-ID:]
      [last_CSeq:]
      [last_From:]
      [last_To:];tag=[call_number]
      [last_Via:]
      Contact: "[field2]" <sip:[field2]@[local_ip]:[local_port]>
      Content-Length: 0

    ]]>
  </send>

  <pause milliseconds="2000"/>

  <send>
    <![CDATA[

      SIP/2.0 200 OK
      [last_Call-ID:]
      [last_CSeq:]
      [last_From:]
      [last_To:];tag=[call_number]
      [last_Via:]
      Content-Type: application/sdp
      Contact: "[field2]" <sip:[field2]@[local_ip]:[local_port]>
      Content-Length:[len]

      v=0
      o=[field2] 3216549878 3216549878 IN IP[local_ip_type] [local_ip]
      s=A SIPp Fan
      t=0 0
      c=IN IP[media_ip_type] [media_ip]
      m=audio [media_port] RTP/AVP 0 101
      a=rtpmap:0 PCMU/8000
      a=rtpmap:101 telephone-event/8000

    ]]>
  </send>

  <recv request="ACK" crlf="true">
  </recv>

  <recv request="BYE">
  </recv>

  <send>
    <![CDATA[

      SIP/2.0 200 OK
      [last_Call-ID:]
      [last_CSeq:]
      [last_From:]
      [last_To:];tag=[call_number]
      [last_Via:]
      Content-Type; application/sdp
      Contact: "[field2]" <sip:[field2]@[local_ip]:[local_port]>
      Content-Length: 0

    ]]>
  </send>

  <pause milliseconds="4000"/>

  <ResponseTimeRepartition value="10, 20, 30, 40, 50, 100, 150, 200"/>
  <CallLengthRepartition value="10, 50, 100, 500, 1000, 5000, 10000"/>
</scenario>
XML

receiver_scenario.registration_scenario = registration_scenario
receiver_scenario.save!

target = Target.find_or_create_by_name_and_address 'Dev Sink', 'sink.local.treadmill.mojolingo.net'

profile = Profile.find_or_create_by_name('Small run')
profile.update_attributes!(
  calls_per_second: 1,
  max_calls: 10,
  max_concurrent: 5,
)

user = User.first_or_create! first_name: 'Admin', last_name: 'User'
user.admin = true
user.admin_mode = true
user.save

test_run = TestRun.first_or_create! name: 'My simple test run',
                        profile: profile,
                        target: target,
                        scenario: main_scenario,
                        receiver_scenario: receiver_scenario
test_run.user = user
test_run.save!
