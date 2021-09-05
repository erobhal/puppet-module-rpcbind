require 'spec_helper_acceptance'

describe 'rpcbind class' do
  context 'rpcbind' do
    context 'with default values for all parameters' do
      context 'it should be idempotent' do
        it 'should work with no errors' do
          pp = <<-EOS
          include rpcbind
          EOS

          # Run it twice and test for idempotency
          apply_manifest(pp, :catch_failures => true)
          apply_manifest(pp, :catch_changes  => true)
        end
      end

      context 'should contain resources' do
        pp = <<-EOS
        include rpcbind
        EOS

        apply_manifest(pp, :catch_failures => true)

        describe package('rpcbind') do
          it { is_expected.to be_installed }
        end

        describe service('rpcbind') do
          it { is_expected.to be_running }
          # Serverspec attempts to use chkconfig for EL 8 which fails.
          if fact('osfamily') == 'RedHat' and fact('operatingsystemrelease') =~ /^8/
            describe command('systemctl is-enabled rpcbind') do
              its(:exit_status) { should eq 0 }
            end
          else
            it { is_expected.to be_enabled }
          end
        end
      end
    end
  end
end
