# P3 – BGP EVPN
## 1. In the 42 VM

```bash
# clone repo (or pull)
cd BADASS-chchao

# build all P3 images
cd P3/SetupImages
for d in rr_lgirault_1 router_chchao_1 router_lgirault_2 router_thrio_3 host_chchao_1 host_lgirault_2 host_thrio_3; do
  (cd "$d" && docker build -t "p3-$d" .)
done
```

Or build one by one, e.g.:

```bash
cd P3/SetupImages/router_chchao_1 && docker build -t p3-router_chchao_1 .
```

## 2. GNS3

- Open GNS3 in the VM.
- Create a new project (or import your exported P3 project).
- Add Docker appliances: for each node choose the matching image (e.g. `p3-router_chchao_1`, `p3-rr_lgirault_1`, `p3-host_chchao_1`).
- Wire the topology (RR ↔ VTEPs, each VTEP ↔ host).
- Start all nodes. Config is inside each image (frr.conf, init scripts).

## 3. Checks

- On RR: `vtysh -c "show bgp l2vpn evpn summary"` (neighbors up).
- On a VTEP: `vtysh -c "show bgp l2vpn evpn route-type 2"` (type 2 when hosts are up).
- Ping between hosts (add IPs on hosts if your scripts don’t set them by default).

No need for Dockerfiles at runtime—only to build the images once in the VM.
