# BADASS-chchao

P1, P2, P3 network labs (GNS3 + Docker, VXLAN, BGP EVPN).

**Note:** Replace `P1/gns3/`, `P2/gns3/`, `P3/gns3/` ZIP files with real GNS3 exports (File → Export portable project, include base images) before submission.

## Structure

```
P1/     GNS3 + Docker images (host, router)
P2/     VXLAN static + multicast
P3/     BGP EVPN + RR
common/ Build scripts
```

## Evaluator – Quick start

### 1. Clone and build

```bash
git clone <repo_url>
cd BADASS-chchao
cd common && bash scripts/build_all.sh
```

### 2. P1 – GNS3 + Docker

- Import `P1/gns3/P1_chchao.gns3project.zip` in GNS3 (File → Import).
- Start nodes: host (`chchao-*_host`), router (`chchao-*`).
- In router console: `vtysh -c "show running-config"` → BGPD, OSPFD, IS-IS active.
- In host: `busybox` available.

### 3. P2 – VXLAN

**Static (first):**

- Import `P2/gns3/P2_chchao.gns3project.zip`.
- On VTEP1: run `P2/config/chchao-vtep1-static.sh`.
- On VTEP2: run `P2/config/chchao-vtep2-static.sh`.
- On host1: run `P2/config/host_chchao-1.sh`.
- On host2: run `P2/config/host_chchao-2.sh`.
- Ping: `host1 → ping 20.1.1.20`, `host2 → ping 20.1.1.10`.
- Inspect traffic (VNI 10).

**Multicast (second):**

- On VTEP1: run `P2/config/chchao-vtep1.sh`.
- On VTEP2: run `P2/config/chchao-vtep2.sh`.
- Same hosts, same ping.
- Inspect traffic (group 239.1.1.1, VNI 10).

### 4. P3 – BGP EVPN

- Import `P3/gns3/P3_chchao.gns3project.zip`.
- RR: load `P3/config/chchao-rr-frr.conf`.
- VTEP1/2/4: run `chchao-vtep*-linux.sh`, then load `chchao-vtep*-frr.conf`.
- Hosts: run `host_chchao-1.sh`, `host_chchao-3.sh` (no IP yet).

**Type 3 only (hosts off):**

- Disable all host nodes in GNS3.
- `vtysh -c "show bgp l2vpn evpn route-type 3"` → type 3 only.

**Type 2 (one host, no IP):**

- Enable host_chchao-1 only, run `host_chchao-1.sh` (no IP).
- `vtysh -c "show bgp l2vpn evpn route-type 2"` on a VTEP → type 2 appears.

**Ping (all hosts, with IPs):**

- Enable all hosts.
- On host1: `host_chchao-1-ip.sh` (adds 20.1.1.10/24).
- On host3: `host_chchao-3-ip.sh` (adds 20.1.1.30/24).
- Ping between hosts.
- Inspect traffic (VNI 10, OSPF visible).
# 42_BADASS-my-own-virtual-network-infrastructure-
