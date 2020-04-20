# GOF3R

[![Build Status](https://travis-ci.com/beacon-biosignals/GOF3R.jl.svg?branch=master)](https://travis-ci.com/SimonDanisch/GOF3R.jl)
[![Codecov](https://codecov.io/gh/beacon-biosignals/GOF3R.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/beacon-biosignals/GOF3R.jl)

Very lightweight wrapper around [s3gof3r](https://github.com/rlmcpherson/s3gof3r).
Offers:

```julia
"""
    s3stream(bucket, path)

Return an `IO` object streaming `path` from `bucket`.
"""
s3stream(bucket, path)

"""
    s3getfile(bucket, path, outfile)

Write the file at `bucket:path` to `outfile`.
"""
s3getfile(bucket, path, outfile)

"""
    s3upload(bucket, file, key)

Upload `file` to `bucket:key`.
"""
s3upload(bucket, file, key)

"""
    s3stream(f, bucket, path)

Call `f(s3stream(bucket, path))`, ensuring that the stream is closed properly once `f`
has finished executing, including in the case of errors.
"""
s3stream(f, bucket, path)
```

You need to set up the authorization as outlined at https://github.com/rlmcpherson/s3gof3r#gof3r-command-line-interface-usage
```
export AWS_ACCESS_KEY_ID=<access_key>
export AWS_SECRET_ACCESS_KEY=<secret_key>
```
gof3r also supports IAM role-based keys from EC2 instance metadata. If available and environment variables are not set, these keys are used are used automatically.
For 2 factor authentication you can also set `AWS_SECURITY_TOKEN` to your session token.
A little script doing 2 factor auth for you with aws-cli:

```julia
using JSON3
awspath = joinpath(homedir(), ".aws")
isdir(awspath) || mkdir(awspath)
credpath = joinpath(awspath, "credentials")

# Write initial user for connection without mfa
# DONT EXECUTE THIS IF YOU ALREADY HAVE A CREDENTIAL FILE!!!!!
# THIS WILL OVERWITE ANY EXISTING CRENTIAL FILE
write(credpath, """
[main]
aws_access_key_id=*********
aws_secret_access_key=********
""")

code = 000000 # your valid code from your 2 factor APP
userid = 0000000000 # your user id from AWS
username = "username" # your username
json = String(read(`aws sts get-session-token --serial-number arn:aws:iam::$(userid):mfa/$(username) --token-code $code --profile=main`))
creds = JSON3.read(json).Credentials

write(credpath, """
[default]
aws_access_key_id=$(creds.AccessKeyId)
aws_secret_access_key=$(creds.SecretAccessKey)
aws_session_token=$(creds.SessionToken)
""")

ENV["AWS_ACCESS_KEY_ID"] = creds.AccessKeyId
ENV["AWS_SECRET_ACCESS_KEY"] = creds.SecretAccessKey
ENV["AWS_SECURITY_TOKEN"] = creds.SessionToken
```

And additionally set `AWS_REGION` and `AWS_ENDPOINT`, which default to:
```julia
if !haskey(ENV, "AWS_REGION")
    ENV["AWS_REGION"] = "us-east-2"
end
endpoint = get(ENV, "AWS_ENDPOINT", "s3.us-east-2.amazonaws.com")
```
