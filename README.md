### Very simple example of how to connect 2 VPCs to a transit gateway.

Add a `profile` section to the `_provider.tf`, choose a region, and you're good to go.

This will create:
- Transit Gateway
- 2 VPCs, with:
  - Attachment to the Transit Gateway
  - Internet Gateway
  - Private, and Public versions of:
    - Subnets
    - Route table
    - Route to transit gateway



