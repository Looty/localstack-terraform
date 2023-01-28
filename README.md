# LocalStack + Terraform Playground

## Running localstack locally
```
docker run --rm -it -p 4566:4566 -p 4510-4559:4510-4559 localstack/localstack
```

## Running terraform test locally (via TF test)
```
terraform test
```

## Running terraform test locally (via Terratest)
```
cd test
go test -count=1 #caching
```