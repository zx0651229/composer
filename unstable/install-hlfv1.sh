(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��-Y �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[�/�$!�:���Q����u|���`�_>H�&�W�&���;|Aq�q��"�1��R#?�9����vZ�}Y��v��\��(�G�O|?�������4^f2".�?E�J�%�5�ߦ��2.�?�Qɿ�Y���T��%	���P�wo{�{�h�\�Z��r�K���l��+�r��4�V�/��5��N�;�����q0Ew�~z-�=�h, (J�ԗZ���w�O�x��r���C�1�Fhsp�<��)�r	��ILS�C6�,BQ>B:>���`��x�(��M�Yc���Q��O�"^��8�>��x�M�!et������Ć��D^�ZO�M`���h�� ���@EYF�]6�/L�&����(ŵ`��l�ZЦ
3!���S>�A���U��,r�4A�8�:VblRzw��xn��E���uVz:��)K����ԍp7��A*�D������8�uY����G�D�ˁ/ԵoߠScEUx�1���M�K�������������?
#���R�Q�˸:��N���=^��(�cO�?NW��<�����$�ڼ����7�n7�́P֔��'���e�ϚKq�"Zhsa���gݞ�	`ƅ����Y��i1o���h(ō :yNik�����֍��2ġ�i�<n��L���xYCrf�ԙsu0�O�m�w���q'�ǅ������b<j����)1�C�Aɕ��`!��C.��z�O�-A�(`~n�D�MSى�C�C�����������N���9�5�țr7�6�8Xs�*���f�b.�~�|������[K���
�4���6A(�(:�)( 2�T_#Bi���Ю/滑D���H���`��Ɗ�Q+S��_vЦ�6��0�Y�%C��#�w��f��9�[ݙ��\����� �������k�Q���N}��=/�����V�x.,)@�@�����u���(��EƤ����7+&@fK��(�t isy�1����R��(y��@����u��@.|[$�%���1�e�����}v�7��k�r�-'iKj����Ũ��,��Ez ǢϙE/�f�\�}X|`6<���,����i����X�������(���*��O�+l�����k�/�
�w�;�ׁzd�7�;u��%�-��=q��%��|�!G�8*�#F��P�1��	���#;� � WS�.�
�{e�ާ)����u��e��i(��C�ل��<��.G�މE�r	��b�֐�ek�Dj�b��.:7��,��ty�H�\̭�m�.�}
@s�e�Rw���=s�mu�4@.�'���	s�0��ax�@����4���Y�@��"�9�W ������k��k��Aȁ3_�A7��}���|Ƿ4�צ����4���A#�9�u �-�5�.��̶��	�4���qG�"j>ob��bM�CAn�{�I���sn
��L�k�t���mfՇJ&�����)~I�����]��!�*��|����y���P4V���������?��������������/��3�*��T�?U�ϯ�ҧ� 'Q���f�����CД�4�2��:F������8�^��w������(��"���+����8؏;���p����.��g	}��@���p�����ֲ�۶̈ɸ!'MS�L���-eXO6C����c�}��t�Y�̱�1G[K|���n�,�F	�6Kٞ�U��{�K��3����R�Q�������e�Z�������j��]��3�*�/$�G��S���m�?�{���
���#��fk�/���0�`��ˇ��Fߛ586}&�C\��v��}�@��r���L�1ɤޛJsk:�LІ����CE�ctW$a��:�;^o�a�����5Q�Ǡ)Q/�q1A�:ܠ�ɪc��,�=Ѻ�i[<2.g�cDґ����9��A�6h�p�4�Cr��mEl	`�8�v�vS4���MV&�����-�3�q�|�0�ٓA�28	LE5�xǰW�|h֣�ZLB6ޮ;-�mvZgiϔ��uG=��f�TS�%������d�R$/k7t !s���IV=h��x��_����C������g��T�_
*����+��ϵެ�]��G�]��h����%���_�����ۊ��@���W��������R�m-R�*��\��c�^8���`h@��C0���xκ��8�0,���0��(͒$eWQ~�ʐ���]����+���L���j�*�7�[c�`��Ǟ#���~����� ���P�;aw괒RCCrG�v��|�a�' �؍r��*mw;p{G��=1@<Z���&#���9���n7���ލ��?N=?��#�/���b�W�)x���'���w��P�����B�߾�L)\.����_
�+���/_V�˟�1���H����b���j�o)��0}����������F���g1"`1Ǳm�el��P��%X�=,�h��]�� g	&�f�G����P��/_�����O�������.���}�Z"&
/&�nPo��4L�˹z�t�H�����?�M��]��簺��\��@w��G��p��|�y�H>h��[>#~*�m��C��Z�D\TG��A�ك��W�?��G��������#���+������S��B���+�4�d_-T�L�!�W�B�?��&���W^��j�<���ϝ���k�KX0�}C~v��x���?K�ߟ����q����r1��Zo�H_������~�9���9���A��=zд�æ�[&N>��)��/��#݅����A?�$��}�؄q��1r-��f��Ex�p�LNp�ɬ'��x��bs5�9jo�EsI�٠��`�uF9��z��2<�Q&�=b��Mb����k�Mba΅�x|�s�[SW�e�"Ek�
?o@���P�r<����T���xl�A�Z�n�yP�:#���6\����`t�A�	NSΦ�4o���7�ڊlt��H�,�e�S����Ӷ7���{@��p��f�	zR.�do��l��-�U].��x�4������������q���K�oa�Sxe��M��������-Q��_�����$P�:���m�G�~�Ǹ0l�^�-��If�����l�G���?�e~��P~�(�|�n#�[�������<�Z�� 컦�Oܖ����yЃ!c;9�ݔ����E%qG4�f#�e�\k�-[�)Ѷw�o�T�]K�t*�1I�4�.�S��]K$�_����4^;zz ��σ8��Х��cs �5�͑��hmւg�.��}{��Y#Yͥ.���d.���j�l��;�j��7|��N�aFHt��*�>=l<����O����� .������J�oa����?��?%�3�����A������?+���Q��W�������F���S`.�����?�����uw1�cBU񟥠����+��s���X�����?�����������1%Q�q(�%\���"��� p���G	�X�
p�G(��������
e����G翐T��S
.����)�rrط̩�f�/0DhN=���l��y�-Z����?� ��q[iXW��E��5��ľ����UQRs̡��+8��)L�Z:Yg�Q�&���F}���ش������ݹ��?J�̿�G������?z�����E���*[?�
-����e~���~���\9^j�id����d������b:��N�+���c���B��k��^$������2��s%��UM�.�7<�iv��]���^�᧧&q�ξ��/!���?�:�7����Z6�]�����Q;�w]�*R����t��^���о/t�+���������jWN������o��U��N]�����G��%��}}�S���rmO�~z���bT���]ePQ��V�9O��2�n�]4��� �~�UQ����7D�.��ߐ��ϋ��׾�WD���e�ZQI��`�;j���y�av}�(�΢г/7�˃����·��śWK���Q��l/V`t�7E�p�xV{����ǒ�LZ�����q��q����N��+��o?�M�v�����U������g�����@.*�=,��SS�8�O��7M���8Y�a���	��.Nד�s]��L�GR��j�h�B"GE��H	����}7@���?���Y����?V��Wtñ�E��������w�F���Y��{�@�Uő�m�n��ɦR��וU��f9�}�axgkxk�p�Y�gK�:{8�O��Ÿ-����{�UT����6�u����r9<.��r�˘�b���u�K��tݺ�t�ֽoJ�=]�n�֞v��5!&��4�o4B�@�D?)����A	$D�`����ж�z��휝����&�t��y���������y�d:c�lr�rSn%d"v���D2A�")<]F;�Y#�L&���LG�a\��e혀��I��,/L��p:�ǭ��7�r`��ѱ��b 6t/��5 h��s�3�ۄ�J�ńq!v�E�Q�%I������v��k�&��u#��
�k�Cn��4�0�Rt�kq���3V3EL<�d�v[�t�ԵQ�w����|x�Y����P�����&3ّ鶐-$��[�'�%��*|��H�w�w�8g܄�e���_3�\We�ДF�#!2�R��8�.�F�j�5�w���Bi1^2f^�[��[7gyQc4E��)��F�E�E�e�6��Q�ti&Nm8=�����_�S�;��ɉ����4�b|�\]������iU��=�s�g�w�yN��S�9�uPK�!ˠ�Hҩ��#U��q���YG�S���=�Re�EXs�7#�ˈ�H���׌�����|t�D��8��U���.s�fGW���u�q�]d��SyV��R�6y����U�.r�\�lQ�I�Z;[3o u��j����g��d&/G��O�����g�uT�h��*�7V�x�s.���=��k�n���4m&?�t눅��8/��f��8��ˈ	���91�{�*���v.����7��Z��|WW�%�Ѕ����÷9Z���������3w��T��WU�1�p�i�捣�����#`>��&�m�߭:����F��f��������w?�W��!PX;�qj��?���Z*q�m����<�j �S��ȶ�W�~ԍm{Y�^϶�Zu�� Ώp��r���������g~��c�V3�=��o�_~�k����W(�v+�x��~�׌�����w��^�s�G��U��3�o���87s��' 59cS��xS��~qS�#0��)n^�gq�������"���\���zt��K�x�s��:^��'���Z�����o����.�6�����۰;�(���`� G�~�t�9!"om��Wh3�B��^����\?_%w����|q�G�L=_N�s��[��K����6'�Ka�ȳ�Nw���)%�
G{����4�����b=�DY|"�H��[�(�2�젯d����"R��ճ�%���(W���������\
Jj��жJ�*S,����RS
��z���`���z��̈́���6v&,���2��a�S�z�km�	����-5C��֞�+!�V5���֢隒��� ��U�O2Ii�M��\=.�}-�x��&��\�D�����	�w$�3a2�p��	�CYIf�a�H�����P;�a���O�sȺGxFv�`Y�Nd&h?�U�C��Z-+�]����O�"M�i^�Ɓ�a�4W�4��g���f"X���!�h�����Ϗ1�}��|��%|Lʲd�e�rg6s�)��Rܷé���;���4�
H��#Т��Z�p>�!��,��WB�0VL��&,�)��VZ��++�*hnS�S���V��.����i����LKJ�)��٥�U=x�W�iߐ$�.�[V�4�]�HT�z��&-∩,�a����D��B�*����H�ɔ�B5���b��*.���[�,����_Y�+(K��x�B�
�GI��g�����&���j��v��~%��-�0԰�ƕhQ��ɵ�J�����#1��&��pNY�b�&�܋������r�3e�A�e����ReaB��w��������PR���t��5�r�l�M�}� �o6$u�G$�ZS�ڄ��y
u�P�d�"[� ��ۓ,v�~��}6�g�}��|��S��Ӝ(����ڼ�A�έ]	m@k�)�+6�@�M�J[�<`|]����Sy֡3�y֯��*ͳ�CU�q�.ȶ9��˝6t#t���u55K�np�Py�sPJ�j� �	�܀s��qI�ܸ�D�b
i^k�5��MUu=���[ZG�Z�N���,ɖ�\k�&S�����5�����!g~�aݦ�ꜳЙ�� 0��~� n�<+�*fˡ[��u�k��1U��m���Ĵ��).+z�<8�+���
�9��3�=m �@�e��x�AN�, �j3����r���ou�#7�"/o�Co�C[�-�~)�_
V~)x���{��`�Zx�n��R�T�X!H�pw˳��[xP8��-u$D�RGc��pv4h��F��5�=E�ꂃ�=Np�'���1ݬ)����A�=`� |"���w�Ԧ��I��a#
a�@e�HqKK4�C�G�!$��z/@r^!�E���SʣyݹM��ƕ|��0X�q��ʡ�=8T�x
��{>�G�B�8��Ocb<$��Cv���5I�� �Q�7��w����J1���H��0�K����>�H������RPQ�ٰi�.Ε��5�0������>Ջ	���n���T׺��) �ԡ���L�jZ������ᴍ�6�8�c]�^���m�Sy˔sy���Ǝ�t��ϴb������o��p=t�ʰ��N<,���{���'���?����r_ˎ�}p"i�"����(�+I���U.�D똗`s
d���Gv�T,E�:΃Ճ"�LPdG�LZFA��fMYVz<�-\��C��$01������H2�#b;�qj�@����A�`J�G�.
@��tI��(����rw��(�.�$��	�ha:�7ٍ���v�n�ÄH�-5�vԳ����<9$�J�m�>�|ig p�X������WJU�$/�a�g�B��Q?��]ْ��wxX[�\ �dI^+�K�H��M�Z�D
�.����e�m�o�q(��=�[�)s�)�ɱB�k���
a����V3lb�l���ZKȴ���f�p�?z�aJ|}��+��4^�{�p���?�ǅ� � 6!Z�2Q���w@p�^�{.�j4I'����{X̮W��[���4B�����z��w}饿<��ǡk��@X��v�k���f���\ǁ�OԻw�j�?/K�ǳ���'�ݗ�8��_������M}�ɯ�@���I�{q�T|'��ֵ+�_���=���t�Zڀξ������3_l�N��3NϿ^�ͯ�COB�S�5
�#�i����zs����M����6�Ӧ	�4��i�}�ŵ�v@ڦv��N��i�l���~�v�oy��A�\��g	#�0�M�M^�n[D�d<b��[��:�c��{ȟ�8�6EMx�y�[g��O���T�g`�m����#�.��r�^��f��Ӳ����V{Ό=-��`ϙ���6��0g��}�0�r�̹p�a�C��V�m����c$s���5p�蟝�d';��}��'d�  