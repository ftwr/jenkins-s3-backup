# Delete all files in the workspace
#rm -rf *
# Create a directory for the job definitions
mkdir -p $BUILD_ID/jobs

# Copy global configuration files into the workspace
cp $JENKINS_HOME/*.xml $BUILD_ID/

# Copy keys and secrets into the workspace
cp $JENKINS_HOME/identity.key.enc $BUILD_ID/
cp $JENKINS_HOME/secret.key $BUILD_ID/
cp $JENKINS_HOME/secret.key.not-so-secret $BUILD_ID/
cp -r $JENKINS_HOME/secrets $BUILD_ID/

# Copy user configuration files into the workspace
cp -r $JENKINS_HOME/users $BUILD_ID/

# Copy custom Pipeline workflow libraries
cp -r $JENKINS_HOME/workflow-libs $BUILD_ID

# Copy job definitions into the workspace
rsync -am --include='config.xml' --include='*/' --prune-empty-dirs --exclude='*' $JENKINS_HOME/jobs/ $BUILD_ID/jobs/

# Create an archive from all copied files (since the S3 plugin cannot copy folders recursively)
tar czf jenkins-configuration.tar.gz $BUILD_ID/

# Remove the directory so only the tar.gz gets copied to S3
rm -rf $BUILD_ID
