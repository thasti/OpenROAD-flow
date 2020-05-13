#!/usr/bin/env python2

import argparse  # argument parsing
import json  # json parsing
import os  # file operations
import subprocess  # process calls
import sys
from collections import OrderedDict

# TODO: These should be arguments
threshold = 32 * 32
vTemplate = "./util/mem_map_template.v"

# 0: Parse and validate arguments
# ==============================================================================
parser = argparse.ArgumentParser(
    description='Generates memory macros and map file for yosys')
parser.add_argument('--memJson', '-j', required=True,
                    help='Input memory dump from yosys')
parser.add_argument('--memMap', '-m', required=True,
                    help='Output memory map verilog to yosys')
parser.add_argument('--bsgResultsDir', '-b', required=True,
                    help='BSG Fakeram results dir')
args = parser.parse_args()

# 1: Read Memory dump and generate config for bsg_fakeram
# ==============================================================================
# Open memory dump
with open(args.memJson) as f:
  memJson = json.load(f, object_pairs_hook=OrderedDict)


fakeramCfg = OrderedDict()
fakeramCfg = {"tech_nm": 45,
              "voltage": 1.1,
              "metalPrefix": "metal",
              "pinWidth_nm": 70,
              "pinPitch_nm": 140,
              "snapWidth_nm": 190,
              "snapHeight_nm": 1400,
              "flipPins": True,
              "srams": []}

for module in memJson["modules"]:
  for memInst in memJson["modules"][module]["cells"]:
    # Set localvars:
    rd_ports = memJson["modules"][module]["cells"][memInst]["parameters"]["RD_PORTS"]
    wr_ports = memJson["modules"][module]["cells"][memInst]["parameters"]["WR_PORTS"]
    width = memJson["modules"][module]["cells"][memInst]["parameters"]["WIDTH"]
    depth = memJson["modules"][module]["cells"][memInst]["parameters"]["SIZE"]

    # if exist in cache do nothing
    # TODO
    # if exists in config also do nothing
    # TODO
    # else check if RD_PORTS!=1
    if rd_ports != 1:
      print "Skipping", memInst, "with", rd_ports, "read ports (Unsupported)"
    # else check if WR_PORTS!=1
    elif wr_ports != 1:
      print "Skipping", memInst, "with", wr_ports, "write ports (Unsupported)"
    # else check if too small to bother with
    elif depth * width < threshold:
      print "Skipping", memInst, "with", depth * width, "bits ( threshold", threshold, ")"
    else:
      print "Adding config for", memInst
      # TODO Perhaps ignore small rams
      fakeramCfg["srams"].append(
          {"inst": memInst,
           "name": "fakeram45_{rd_ports}r{wr_ports}w_{depth}x{width}".format(depth=depth,
                                                                             width=width,
                                                                             rd_ports=rd_ports,
                                                                             wr_ports=wr_ports),
           "width": width,
           "depth": depth,
           "rd_ports": rd_ports,
           "wr_ports": wr_ports,
           "banks": 1}
      )

# Debug
# print json.dumps(fakeramCfg, indent=2)

# 3: Generate memories using bsg_fakeram
# ==============================================================================
# if srams>1, export and run bsg_fakram
if fakeramCfg["srams"]:
  head, tail = os.path.split(args.memJson)
  root, ext = os.path.splitext(tail)
  fakeramCfgFile = os.path.join(head, root + ".cfg")
  with open(fakeramCfgFile, "w") as resultSpecfile:
    json.dump(fakeramCfg, resultSpecfile, indent=2)

  make_proc = subprocess.check_call(["make", "CONFIG=" + os.path.abspath(fakeramCfgFile)], cwd=os.path.dirname(args.bsgResultsDir))
else:
  print "No memory macros to generate"


# 3: Generate tech map
# ==============================================================================
snippet = ""
if fakeramCfg["srams"]:
  for i in range(len(fakeramCfg["srams"])):
    snippet += """
      generate
        if (MEMID=="\\\\{inst}") begin
          fakeram45_{rd_ports}r{wr_ports}w_{depth}x{width} u_fakeram45_{rd_ports}r{wr_ports}w_{depth}x{width} (
            .clk(RD_CLK),
            .addr_in(addr_in),
            .ce_in(ce_in),
            .rd_out(RD_DATA),
            .we_in(we_in),
            .wd_in(WR_DATA),
            .w_mask_in(WR_EN)
          );
          initial begin
            _TECHMAP_FAIL_ <= 0;
            // only map cells with only one read and one write port
            if (RD_PORTS > 1 || WR_PORTS > 1)
              _TECHMAP_FAIL_ <= 1;

            // we expect positive write clock
            if (!WR_CLK_ENABLE || !WR_CLK_POLARITY)
              _TECHMAP_FAIL_ <= 1;

            // read and write must be in same clock domain
            if (_TECHMAP_CONNMAP_RD_CLK_ != _TECHMAP_CONNMAP_WR_CLK_)
              _TECHMAP_FAIL_ <= 1;
          end
        end
      endgenerate
    """.format(inst=fakeramCfg["srams"][i]["inst"],
               depth=fakeramCfg["srams"][i]["depth"],
               width=fakeramCfg["srams"][i]["width"],
               rd_ports=fakeramCfg["srams"][i]["rd_ports"],
               wr_ports=fakeramCfg["srams"][i]["wr_ports"])

# Debug
# print snippet

# Read in the file
with open(vTemplate, "r") as file :
  filedata = file.read()

# Replace the target string
filedata = filedata.replace('###AUTO_GENERATED_RAMS###', snippet)

# Write the file out again
with open(args.memMap, "w") as file:
  file.write(filedata)

