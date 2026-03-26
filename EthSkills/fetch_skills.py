import urllib.request
import os

urls = [
    "https://ethskills.com/ship/SKILL.md",
    "https://ethskills.com/why/SKILL.md",
    "https://ethskills.com/protocol/SKILL.md",
    "https://ethskills.com/gas/SKILL.md",
    "https://ethskills.com/wallets/SKILL.md",
    "https://ethskills.com/l2s/SKILL.md",
    "https://ethskills.com/standards/SKILL.md",
    "https://ethskills.com/tools/SKILL.md",
    "https://ethskills.com/building-blocks/SKILL.md",
    "https://ethskills.com/orchestration/SKILL.md",
    "https://ethskills.com/addresses/SKILL.md",
    "https://ethskills.com/concepts/SKILL.md",
    "https://ethskills.com/security/SKILL.md",
    "https://ethskills.com/audit/SKILL.md",
    "https://ethskills.com/testing/SKILL.md",
    "https://ethskills.com/indexing/SKILL.md",
    "https://ethskills.com/frontend-ux/SKILL.md",
    "https://ethskills.com/frontend-playbook/SKILL.md",
    "https://ethskills.com/qa/SKILL.md"
]

output_file = "c:/WEB3/EthSkills/eth_skills_combined.md"

with open(output_file, "w", encoding="utf-8") as outfile:
    outfile.write("# Ethereum Web3 & Smart Contract Skills\n\n")
    for url in urls:
        print(f"Fetching {url}")
        try:
            req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
            with urllib.request.urlopen(req) as response:
                content = response.read().decode('utf-8')
                outfile.write(f"\n\n---\n## Source: {url}\n\n")
                outfile.write(content)
        except Exception as e:
            print(f"Error fetching {url}: {e}")

print("Successfully grabbed all skills!")
