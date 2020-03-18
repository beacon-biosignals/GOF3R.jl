# GOF3R

[![Build Status](https://travis-ci.com/beacon-biosignals/GOF3R.jl.svg?branch=master)](https://travis-ci.com/SimonDanisch/GOF3R.jl)
[![Codecov](https://codecov.io/gh/beacon-biosignals/GOF3R.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/beacon-biosignals/GOF3R.jl)

Very lightweight wrapper around [s3gof3r](https://github.com/rlmcpherson/s3gof3r).
Offers:

```julia

"""
  s3stream(bucket, path)
Returns an io streaming path from bucket
"""
s3stream(bucket, path) 


"""
  s3stream(bucket, path)
Writes file from `ucket:path`to `utfile`
"""
s3getfile(bucket, path, outfile)

"""
  s3upload(bucket, file, key)
Uploads `file` to `bucket:key`
"""
s3upload(bucket, file, key)



"""
  s3stream(f, bucket, path)
calls f(s3stream(bucket, path)) and makes sure everything gets closed correctly + error handling.
"""
s3stream(f, bucket, path)
```

You need to set up the authorization as outlined at https://github.com/rlmcpherson/s3gof3r#gof3r-command-line-interface-usage
```
export AWS_ACCESS_KEY_ID=<access_key>
export AWS_SECRET_ACCESS_KEY=<secret_key>
```
```
gof3r also supports IAM role-based keys from EC2 instance metadata. If available and environment variables are not set, these keys are used are used automatically.
```

and additionally set `AWS_REGION` and `AWS_ENDPOINT`, which default to:
```julia
if !haskey(ENV, "AWS_REGION")
    ENV["AWS_REGION"] = "us-east-2"
end
endpoint = get(ENV, "AWS_ENDPOINT", "s3.us-east-2.amazonaws.com")
```
