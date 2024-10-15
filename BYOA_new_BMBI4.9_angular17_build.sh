echo "0 - Start: Hi Developer You have fired Srijan Build."
# BMBI Build Execution
echo "1 and 2- Skip BMBI Build Execution":

echo "3 - Start Creating Output Folder for Srijan  at location: /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan"
rm -R /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan
mkdir -p /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan
mkdir -p /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics
echo "3 - Finish Creating Output Folder for Srijan  at location: /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan"


echo "4 - Start  Pzeon Build Execution"
cd /home/acesocloud2/BMBI_SRC/PzeonAnalytics/tags/pzeon-tag-build/EKS_GRC_BMBI_4.9_lib_src_4.3
#cd /home/acesocloud2/BMBI_SRC/PzeonAnalytics/tags/pzeon-tag-build/EKS_GRC_BMBI_4.9_lib_src_4.4
rm -r /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/DesignerAdminUMSEKSContainer
mkdir -p /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/DesignerAdminUMSEKSContainer
chmod -R 777 /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/DesignerAdminUMSEKSContainer
echo "4.1 - Start  Pzeon BackEnd Execution"
svn update /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/Pzeon_Backend_DevOps
svn update /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/Srijan
svn export /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/Pzeon_Backend_DevOps/src-4.3/ /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/DesignerAdminUMSEKSContainer --force
#svn update /home/acesocloud2/BMBI_SRC/PzeonImplementation/branch/Srijan
svn export /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/Srijan/com /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/DesignerAdminUMSEKSContainer/com --force
#svn export /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/Srijan/handler /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/DesignerAdminUMSEKSContainer/com/pzeon/handler --force
#svn export /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/Srijan/java/AngManager.java /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/DesignerAdminUMSEKSContainer/com/pzeon/customLanding/Ang --force
ant > /home/developer/PzeonAnalyticsTarget_Responsive/Srijan_4.9_angular17_build_output.txt
rm -R /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/DesignerAdminUMSEKSContainer
echo "4.1 - Finish  Pzeon BackEnd Execution"

echo "4.2 - Start  Pzeon Angular8 Build Execution"
cd /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics
mkdir -p /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/SrijanDevBuild
chmod -R 777 /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/SrijanDevBuild
svn export /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/Srijan/ /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/SrijanDevBuild/ --force
#svn export /home/acesocloud2/BMBI_SRC/PzeonImplementation/branch/Srijan/ /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/SrijanDevBuild/ --force
#cd /home/acesocloud2/BMBI_SRC/PzeonImplementation/branch/Srijan
cd /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/SrijanDevBuild 
#zip src.zip src -r
ng build --base-href /pzeon/
#npm run update-version
#ng build --prod --aot=false --buildOptimizer=false --base-href /pzeon/
echo "4.2 - Finish  Pzeon Angular17 Build Execution"

echo "4 - Finish Pzeon Build Execution"


echo "5 - Start Copying/Merging BMBI and PzeonBuild"
cp -R /home/developer/PzeonAnalyticsTarget_Responsive_4.9\(dev\)/PRODUCTION/PzeonAnalytics /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan
chmod -R 777 /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan
echo "5 - Finish Copying/Merging BMBI and PzeonBuild"

echo "6 - Start Pzeon Custom project merging "
#cp -R /home/acesocloud2/BMBI_SRC/PzeonImplementation/branch/Srijan/AppRepo /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics/ --force
cp -R /home/acesocloud2/BMBI_SRC/PzeonImplementation/branch/BYOA/WEB-INF/classes/api /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics/WEB-INF/classes --force
#cp -R /home/acesocloud2/BMBI_SRC/PzeonImplementation/branch/Srijan/AlertEngine /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/ --force


cp /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/Srijan/EKS_Details/Dockerfile /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics
cp /home/acesocloud2/BMBI_SRC/PzeonAnalytics/branch/Srijan/EKS_Details/apache-tomcat-8.5.83.tar.gz /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics
cp /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics/pzeon/index.html /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics


#rm -R /home/acesocloud2/BMBI_SRC/PzeonImplementation/branch/Srijan/pzeon --force
cd  /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics/
zip pzeon.zip pzeon -r
echo "6 - Finish Pzeon Custom project merging "

echo "7 - Start removing unwanted jars/files"
rm /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics/WEB-INF/lib/mongo-2.10.1.jar
rm /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics/WEB-INF/lib/mongo-java-driver-3.6.4.jar
rm /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics/WEB-INF/lib/apns-0.1.5-jar-with-dependencies.jar
rm /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics/WEB-INF/lib/websocket-api.jar
rm /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics/WEB-INF/lib/commons-io-2.4.jar
rm /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics/WEB-INF/lib/fontbox-1.8.13.jar
rm /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics/WEB-INF/lib/pdfbox-1.8.13.jar
rm /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics/WEB-INF/lib/slf4j-api-1.7.12.jar
rm /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan/PzeonAnalytics/WEB-INF/lib/org-apache-commons-codec.jar
#cd /home/developer/MolinaTrunkMinificationApp
# Remove Apache poi 3.9 jars
echo "8 - Finish removing unwanted jars/files"

echo "9 - Finish: Hi Developer Your  Build Fired Successfully."

echo "****** Build Location is: /home/developer/PzeonAnalyticsTarget_Responsive/PRODUCTION/Srijan"

sh /home/acesocloud2/BMBI_SRC/PzeonAnalytics/trunk/build/SRIJAN/Srijn/BYOA_docker_build.sh
