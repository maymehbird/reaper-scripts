# Manual acceptance test: Auto Exclusive Solo

Run in a throwaway REAPER project with at least three ordinary tracks (A, B, C). Confirm behavior in the TCP **and** MCP.

1. Start with A soloed before running the script. Run script. **Expected:** A remains soloed.
2. Click S on B. **Expected:** B soloed, A cleared within the next UI cycle.
3. Click S on C. **Expected:** C soloed, B cleared.
4. Click S on C again. **Expected:** C unsoloed, none soloed (ignoring solo-safe tracks).
5. Enable a solo-safe state on A using REAPER. Click S on B. **Expected:** solo-safe A remains unchanged, B is soloed.
6. Solo several tracks simultaneously with a REAPER operation. **Expected:** if detected in one deferred tick, this newly soloed set remains together.
7. Switch to a different project tab containing solos. **Expected:** existing solos are not cleared merely by tab switching. A later newly soloed track causes the previous normal solos to clear.
8. Check solo behavior while track routing, folders, and solo-defeat settings are active. **Expected:** no surprises. This needs real-host verification.
9. REAPER restart without the startup action. **Expected:** regular accumulated solo behavior (because watcher is no longer active).

Known scope: the implementation detects changes in solo states, not clicks. Background script updates on the next `reaper.defer` cycle and may temporarily allow multiple solos. There is no explicit singleton guard if launched twice.
