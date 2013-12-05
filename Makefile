ci: destroy_dev_env create_dev_env run_tests_in_dev_env

destroy_dev_env:
	vagrant destroy -f

create_dev_env:
	vagrant up dev

run_tests_in_dev_env:
	vagrant ssh dev -c "cd /srv/treadmill/current && rake db\:test\:prepare spec"
