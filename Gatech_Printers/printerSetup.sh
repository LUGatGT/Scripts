#!/bin/bash

# Georgia Tech Printer Setup Script
# Compatible with most Linux-based systems
# Requires a recent version of CUPS
# Written by Siddu Duddikunta <siddu@siddu.me>

fail()
{
    echo '[FAILED]'
    echo 'A log is available at /tmp/printer_install/log.'
    exit 1
}

LPADMIN=$(which lpadmin)
RAR=$(which unrar)
WGET=$(which wget)
DIALOG=$(which dialog)
CUPSENABLE=$(which cupsenable)
CUPSACCEPT=$(which cupsaccept)
UNZIP=$(which unzip)

if [ -z $LPADMIN ]; then
    echo "error: no lpadmin found (is cups installed?)"
    exit 1
fi

if [ -z $RAR ]; then
    echo "error: no unrar found; please install it"
    exit 1
fi

if [ -z $UNZIP ]; then
    echo "error: no unzip found; please install it"
    exit 1
fi

if [ -z $WGET ]; then
    echo "error: no wget found; please install it"
    exit 1
fi

while true; do
    GT_USER=$($DIALOG --inputbox "GT username:" 8 40 2>&1 >/dev/tty)
    STATUS=$?
    clear
    if [ $STATUS -ne 0 ]; then
        echo "Canceled"
        exit 1
    fi
    if [ -n "$GT_USER" ]; then
        break;
    fi
done

cmd=($DIALOG --separate-output --checklist "Select printers to install:" 22 76 16)
options=(1 "Black Standard" on
         2 "Black Finish" on
         3 "CentralPS" on
         4 "Library Color" on
         5 "BME Color" on
         6 "CE Color" on
         7 "CoA Color" on
         8 "CoB Color" on
         9 "Klaus 1446 Color" on
         10 "Klaus 1448 Color" on
         11 "MRDC Color" on
         12 "Multimedia Studio Color" on
         13 "Student Center Color" on
         14 "Van Leer 448 Color" on)
INSTALL=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear

mkdir -p /tmp/printer_install
cd /tmp/printer_install

echo "Please enter your root password if requested so we can interact with CUPS."
sudo true || fail
echo


echo "==========GT Printer Installation Script Log==========" >> /tmp/printer_install/log
echo "Selections: $INSTALL" >> /tmp/printer_install/log
echo -n "Date/Time: " >> /tmp/printer_install/log
echo `date` >> /tmp/printer_install/log
echo >> /tmp/printer_install/log


for PRINTER in $INSTALL
do
    case $PRINTER in
        1)
            echo "Installing Black Standard..." | tee -a /tmp/printer_install/log
            if [ ! -f "/tmp/printer_install/xr5550dn.ppd" ]; then
                echo -n -e "Downloading driver...\\t" && $WGET "http://www.support.xerox.com/support/phaser-5550/file-redirect/enus.html?operatingSystem=win81&fileLanguage=en&contentId=100080" -O 5550_PPD_Drivers_en-us.exe >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
                echo -n -e "Extracting driver...\\t" && $RAR e 5550_PPD_Drivers_en-us.exe xr5550dn.ppd >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            fi
            echo -n -e "Installing to CUPS...\\t" && sudo $LPADMIN -E -p GTBlackStandard -v "lpd://$GT_USER@pharosQ3.ad.gatech.edu/laptop_black_xerox5550" -L "GT Campus" -D "GT standard black printer; no staple/hole punch" -P /tmp/printer_install/xr5550dn.ppd -o printer-is-shared=false >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            echo -n -e "Setting options...\\t"
            sudo $LPADMIN -p GTBlackStandard -o media=na_letter_8.5x11in -o PageSize=Letter -o InstalledMemory=512Meg -o XRXOptionFeatureSet=DN -o XRXOptionTrays=ThreeExtraTrays -o XRXOptionHD=False -o XRXOptionDuplex=True -o XRXOptionPunch=False -o XRXOptionFinisher=False >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSENABLE GTBlackStandard >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSACCEPT GTBlackStandard >>/tmp/printer_install/log 2>&1 || fail
            echo "[OK]"
            echo
            ;;
        2)
            echo "Installing Black Finish..." | tee -a /tmp/printer_install/log
            if [ ! -f "/tmp/printer_install/xr5550dn.ppd" ]; then
                echo -n -e "Downloading driver...\\t" && $WGET "http://www.support.xerox.com/support/phaser-5550/file-redirect/enus.html?operatingSystem=win81&fileLanguage=en&contentId=100080" -O 5550_PPD_Drivers_en-us.exe >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
                echo -n -e "Extracting driver...\\t" && $RAR e 5550_PPD_Drivers_en-us.exe xr5550dn.ppd >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            fi
            echo -n -e "Installing to CUPS...\\t" && sudo $LPADMIN -E -p GTBlackFinish -v "lpd://$GT_USER@pharosQ3.ad.gatech.edu/laptop_finish_xerox5550F" -L "GT Campus" -D "GT finish black printer; with staple/hole punch" -P /tmp/printer_install/xr5550dn.ppd -o printer-is-shared=false >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            echo -n -e "Setting options...\\t"
            sudo $LPADMIN -p GTBlackFinish -o media=na_letter_8.5x11in -o PageSize=Letter -o InstalledMemory=512Meg -o XRXOptionFeatureSet=DN -o XRXOptionTrays=ThreeExtraTrays -o XRXOptionHD=False -o XRXOptionDuplex=True -o XRXOptionPunch=US_Punch -o XRXOptionFinisher=True >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSENABLE GTBlackFinish >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSACCEPT GTBlackFinish >>/tmp/printer_install/log 2>&1 || fail
            echo "[OK]"
            echo
            ;;
        3)
            echo "Installing CentralPS..." | tee -a /tmp/printer_install/log
            if [ ! -f "/tmp/printer_install/heidelberg9110.ppd" ]; then
                echo -n -e "Downloading driver...\\t" && $WGET "https://www.openprinting.org/ppd-o-matic.php?driver=Postscript&printer=Heidelberg-Digimaster_9110&show=0" -O heidelberg9110.ppd >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            fi
            echo -n -e "Installing to CUPS...\\t" && sudo $LPADMIN -E -p GTCentralPS -v "lpd://$GT_USER@pharosQ2.ad.gatech.edu/laptop_centralps" -L "GT Printing Services" -D "GT central printing service" -P /tmp/printer_install/heidelberg9110.ppd -o printer-is-shared=false >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            echo -n -e "Setting options...\\t"
            sudo $CUPSENABLE GTCentralPS >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSACCEPT GTCentralPS >>/tmp/printer_install/log 2>&1 || fail
            echo "[OK]"
            echo
            ;;
        4)
            echo "Installing Library Color..." | tee -a /tmp/printer_install/log
            if [ ! -f "/tmp/printer_install/xr7500dt.ppd" ]; then
                echo -n -e "Downloading driver...\\t" && $WGET "http://www.support.xerox.com/support/phaser-7500/file-redirect/enus.html?operatingSystem=win81&fileLanguage=en&contentId=116895" -O 7500_PPD_Driver_en-US.exe >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
                echo -n -e "Extracting driver...\\t" && $RAR e 7500_PPD_Driver_en-US.exe xr7500dt.ppd >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            fi
            echo -n -e "Installing to CUPS...\\t" && sudo $LPADMIN -E -p GTLibraryColor -v "lpd://$GT_USER@pharosQ3.ad.gatech.edu/laptop_color_library" -L "GT Library" -D "GT library color printer" -P /tmp/printer_install/xr7500dt.ppd -o printer-is-shared=false >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            echo -n -e "Setting options...\\t"
            sudo $LPADMIN -p GTLibraryColor -o media=na_letter_8.5x11in -o PageSize=Letter >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSENABLE GTLibraryColor >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSACCEPT GTLibraryColor >>/tmp/printer_install/log 2>&1 || fail
            echo "[OK]"
            echo
            ;;
        5)
            echo "Installing BME Color..." | tee -a /tmp/printer_install/log
            if [ ! -f "/tmp/printer_install/xr7500dt.ppd" ]; then
                echo -n -e "Downloading driver...\\t" && $WGET "http://www.support.xerox.com/support/phaser-7500/file-redirect/enus.html?operatingSystem=win81&fileLanguage=en&contentId=116895" -O 7500_PPD_Driver_en-US.exe >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
                echo -n -e "Extracting driver...\\t" && $RAR e 7500_PPD_Driver_en-US.exe xr7500dt.ppd >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            fi
            echo -n -e "Installing to CUPS...\\t" && sudo $LPADMIN -E -p GTBMEColor -v "lpd://$GT_USER@pharosQ3.ad.gatech.edu/laptop_color_bme" -L "Biomedical Engineering Building" -D "GT BME color printer" -P /tmp/printer_install/xr7500dt.ppd -o printer-is-shared=false >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            echo -n -e "Setting options...\\t"
            sudo $LPADMIN -p GTBMEColor -o media=na_letter_8.5x11in -o PageSize=Letter >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSENABLE GTBMEColor >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSACCEPT GTBMEColor >>/tmp/printer_install/log 2>&1 || fail
            echo "[OK]"
            echo
            ;;
        6)
            echo "Installing CE Color..." | tee -a /tmp/printer_install/log
            if [ ! -f "/tmp/printer_install/LinuxCupsPrinterPkg/xrx7400dt.ppd" ]; then
                echo -n -e "Downloading driver...\\t" && $WGET "http://www.support.xerox.com/support/phaser-7400/file-redirect/enus.html?operatingSystem=linux&fileLanguage=en&contentId=61334" -O LinuxCupsPrinterPkg.tar.gz >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
                echo -n -e "Extracting driver...\\t" && tar xf LinuxCupsPrinterPkg.tar.gz LinuxCupsPrinterPkg/xrx7400dt.ppd >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            fi
            echo -n -e "Installing to CUPS...\\t" && sudo $LPADMIN -E -p GTCEColor -v "lpd://$GT_USER@pharosQ3.ad.gatech.edu/laptop_color_ce" -L "School of Civil and Environmental Engineering" -D "GT CE color printer" -P /tmp/printer_install/LinuxCupsPrinterPkg/xrx7400dt.ppd -o printer-is-shared=false >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            echo -n -e "Setting options...\\t"
            sudo $LPADMIN -p GTCEColor -o media=na_letter_8.5x11in -o PageSize=Letter >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSENABLE GTCEColor >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSACCEPT GTCEColor >>/tmp/printer_install/log 2>&1 || fail
            echo "[OK]"
            echo
            ;;
        7)
            echo "Installing CoA Color..." | tee -a /tmp/printer_install/log
            if [ ! -f "/tmp/printer_install/LinuxCupsPrinterPkg/xrx7400dt.ppd" ]; then
                echo -n -e "Downloading driver...\\t" && $WGET "http://www.support.xerox.com/support/phaser-7400/file-redirect/enus.html?operatingSystem=linux&fileLanguage=en&contentId=61334" -O LinuxCupsPrinterPkg.tar.gz >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
                echo -n -e "Extracting driver...\\t" && tar xf LinuxCupsPrinterPkg.tar.gz LinuxCupsPrinterPkg/xrx7400dt.ppd >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            fi
            echo -n -e "Installing to CUPS...\\t" && sudo $LPADMIN -E -p GTCoAColor -v "lpd://$GT_USER@pharosQ3.ad.gatech.edu/laptop_color_coa" -L "College of Architecture" -D "GT CoA color printer" -P /tmp/printer_install/LinuxCupsPrinterPkg/xrx7400dt.ppd -o printer-is-shared=false >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            echo -n -e "Setting options...\\t"
            sudo $LPADMIN -p GTCoAColor -o media=na_letter_8.5x11in -o PageSize=Letter >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSENABLE GTCoAColor >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSACCEPT GTCoAColor >>/tmp/printer_install/log 2>&1 || fail
            echo "[OK]"
            echo
            ;;
        8)
            echo "Installing CoB Color..." | tee -a /tmp/printer_install/log
            if [ ! -f "/tmp/printer_install/XeroxWorkCentre7545.ppd" ]; then
                echo -n -e "Downloading driver...\\t" && $WGET "http://www.support.xerox.com/support/workcentre-7545-7556/file-redirect/enus.html?operatingSystem=win81&fileLanguage=en&&associatedProduct=XRIP_WC7525_base&contentId=119525" -O English.5.250.0.zip >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
                echo -n -e "Extracting driver...\\t" && $UNZIP English.5.250.0.zip XeroxWorkCentre7545.ppd >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            fi
            echo -n -e "Installing to CUPS...\\t" && sudo $LPADMIN -E -p GTCoBColor -v "lpd://$GT_USER@pharosQ3.ad.gatech.edu/laptop_color_cob" -L "College of Business" -D "GT CoB color printer" -P /tmp/printer_install/XeroxWorkCentre7545.ppd -o printer-is-shared=false >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            echo -n -e "Setting options...\\t"
            sudo $LPADMIN -p GTCoBColor -o media=na_letter_8.5x11in -o PageSize=Letter >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSENABLE GTCoBColor >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSACCEPT GTCoBColor >>/tmp/printer_install/log 2>&1 || fail
            echo "[OK]"
            echo
            ;;
        9)
            echo "Installing Klaus 1446 Color..." | tee -a /tmp/printer_install/log
            if [ ! -f "/tmp/printer_install/LinuxCupsPrinterPkg/xrx7400dt.ppd" ]; then
                echo -n -e "Downloading driver...\\t" && $WGET "http://www.support.xerox.com/support/phaser-7400/file-redirect/enus.html?operatingSystem=linux&fileLanguage=en&contentId=61334" -O LinuxCupsPrinterPkg.tar.gz >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
                echo -n -e "Extracting driver...\\t" && tar xf LinuxCupsPrinterPkg.tar.gz LinuxCupsPrinterPkg/xrx7400dt.ppd >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            fi
            echo -n -e "Installing to CUPS...\\t" && sudo $LPADMIN -E -p GTKlaus1446Color -v "lpd://$GT_USER@pharosQ3.ad.gatech.edu/laptop_color_ece_K1446" -L "Klaus Advanced Computing Building 1446" -D "GT Klaus 1446 color printer" -P /tmp/printer_install/LinuxCupsPrinterPkg/xrx7400dt.ppd -o printer-is-shared=false >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            echo -n -e "Setting options...\\t"
            sudo $LPADMIN -p GTKlaus1446Color -o media=na_letter_8.5x11in -o PageSize=Letter >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSENABLE GTKlaus1446Color >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSACCEPT GTKlaus1446Color >>/tmp/printer_install/log 2>&1 || fail
            echo "[OK]"
            echo
            ;;
        10)
            echo "Installing Klaus 1448 Color..." | tee -a /tmp/printer_install/log
            if [ ! -f "/tmp/printer_install/dl5110cn.ppd" ]; then
                echo -n -e "Downloading driver...\\t" && $WGET "https://gist.githubusercontent.com/pwyliu/7274079/raw/14ec0058b77b667141669248700a82a1a31f504d/dl5110cn.ppd" -O dl5110cn.ppd >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            fi
            echo -n -e "Installing to CUPS...\\t" && sudo $LPADMIN -E -p GTKlaus1448Color -v "lpd://$GT_USER@pharosQ3.ad.gatech.edu/laptop_color_ece_K1448" -L "Klaus Advanced Computing Building 1448" -D "GT Klaus 1448 color printer" -P /tmp/printer_install/dl5110cn.ppd -o printer-is-shared=false >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            echo -n -e "Setting options...\\t"
            sudo $LPADMIN -p GTKlaus1448Color -o media=na_letter_8.5x11in >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSENABLE GTKlaus1448Color >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSACCEPT GTKlaus1448Color >>/tmp/printer_install/log 2>&1 || fail
            echo "[OK]"
            echo
            ;;
        11)
            echo "Installing MRDC Color..." | tee -a /tmp/printer_install/log
            if [ ! -f "/tmp/printer_install/LinuxCupsPrinterPkg/xrx7400dt.ppd" ]; then
                echo -n -e "Downloading driver...\\t" && $WGET "http://www.support.xerox.com/support/phaser-7400/file-redirect/enus.html?operatingSystem=linux&fileLanguage=en&contentId=61334" -O LinuxCupsPrinterPkg.tar.gz >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
                echo -n -e "Extracting driver...\\t" && tar xf LinuxCupsPrinterPkg.tar.gz LinuxCupsPrinterPkg/xrx7400dt.ppd >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            fi
            echo -n -e "Installing to CUPS...\\t" && sudo $LPADMIN -E -p GTMRDCColor -v "lpd://$GT_USER@pharosQ3.ad.gatech.edu/laptop_color_mrdc" -L "Manufacturing Related Disciplines Complex" -D "GT MRDC color printer" -P /tmp/printer_install/LinuxCupsPrinterPkg/xrx7400dt.ppd -o printer-is-shared=false >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            echo -n -e "Setting options...\\t"
            sudo $LPADMIN -p GTMRDCColor -o media=na_letter_8.5x11in -o PageSize=Letter >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSENABLE GTMRDCColor >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSACCEPT GTMRDCColor >>/tmp/printer_install/log 2>&1 || fail
            echo "[OK]"
            echo
            ;;
        12)
            echo "Installing Multimedia Studio Color..." | tee -a /tmp/printer_install/log
            if [ ! -f "/tmp/printer_install/LinuxCupsPrinterPkg/xrx7760dx.ppd" ]; then
                echo -n -e "Downloading driver...\\t" && $WGET "http://www.support.xerox.com/support/phaser-7400/file-redirect/enus.html?operatingSystem=linux&fileLanguage=en&contentId=61334" -O LinuxCupsPrinterPkg.tar.gz >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
                echo -n -e "Extracting driver...\\t" && tar xf LinuxCupsPrinterPkg.tar.gz LinuxCupsPrinterPkg/xrx7760dx.ppd >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            fi
            echo -n -e "Installing to CUPS...\\t" && sudo $LPADMIN -E -p GTMStudioColor -v "lpd://$GT_USER@pharosQ3.ad.gatech.edu/laptop_color_mstudio" -L "Library Multimedia Studio" -D "GT mutlimedia studio color printer" -P /tmp/printer_install/LinuxCupsPrinterPkg/xrx7760dx.ppd -o printer-is-shared=false >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            echo -n -e "Setting options...\\t"
            sudo $LPADMIN -p GTMStudioColor -o media=na_letter_8.5x11in -o PageSize=Letter >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSENABLE GTMStudioColor >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSACCEPT GTMStudioColor >>/tmp/printer_install/log 2>&1 || fail
            echo "[OK]"
            echo
            ;;
        13)
            echo "Installing Student Center Color..." | tee -a /tmp/printer_install/log
            if [ ! -f "/tmp/printer_install/xrx7775.ppd" ]; then
                echo -n -e "Downloading driver...\\t" && $WGET "http://www.support.xerox.com/support/workcentre-7755-7765-7775/file-redirect/enus.html?operatingSystem=win81&fileLanguage=en&&associatedProduct=XRIP_WC7755_Base&contentId=107530" -O WC7755_Win-PPD_1.0.18_English.zip >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
                echo -n -e "Extracting driver...\\t" && $UNZIP WC7755_Win-PPD_1.0.18_English.zip xrx7775.ppd >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            fi
            echo -n -e "Installing to CUPS...\\t" && sudo $LPADMIN -E -p GTStudentCenterColor -v "lpd://$GT_USER@pharosQ3.ad.gatech.edu/laptop_color_studentcenter" -L "Student Center" -D "GT student center color printer" -P /tmp/printer_install/xrx7775.ppd -o printer-is-shared=false >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            echo -n -e "Setting options...\\t"
            sudo $LPADMIN -p GTStudentCenterColor -o media=na_letter_8.5x11in -o PageSize=Letter >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSENABLE GTStudentCenterColor >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSACCEPT GTStudentCenterColor >>/tmp/printer_install/log 2>&1 || fail
            echo "[OK]"
            echo
            ;;
        14)
            echo "Installing Van Leer 448 Color..." | tee -a /tmp/printer_install/log
            if [ ! -f "/tmp/printer_install/dl5110cn.ppd" ]; then
                echo -n -e "Downloading driver...\\t" && $WGET "https://gist.githubusercontent.com/pwyliu/7274079/raw/14ec0058b77b667141669248700a82a1a31f504d/dl5110cn.ppd" -O dl5110cn.ppd >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            fi
            echo -n -e "Installing to CUPS...\\t" && sudo $LPADMIN -E -p GTVanLeerColor -v "lpd://$GT_USER@pharosQ3.ad.gatech.edu/laptop_color_ece_VL448" -L "Van Leer 448" -D "GT Van Leer 448 color printer" -P /tmp/printer_install/dl5110cn.ppd -o printer-is-shared=false >>/tmp/printer_install/log 2>&1 || fail && echo "[OK]"
            echo -n -e "Setting options...\\t"
            sudo $LPADMIN -p GTVanLeerColor -o media=na_letter_8.5x11in >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSENABLE GTVanLeerColor >>/tmp/printer_install/log 2>&1 || fail
            sudo $CUPSACCEPT GTVanLeerColor >>/tmp/printer_install/log 2>&1 || fail
            echo "[OK]"
            echo
            ;;
    esac
done

echo "All done! A log is available at /tmp/printer_install/log."
echo "You can print from any application, including GUI applications like Firefox/Chrome and Document Viewer."
echo "To print from the command line, use: lpr -P (PrinterName) (filename)."
echo "You may view installed printers using your browser at http://localhost:631/."

