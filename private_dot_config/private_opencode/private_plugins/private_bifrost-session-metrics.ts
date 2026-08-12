import type { Plugin } from "@opencode-ai/plugin";

export const BifrostSessionMetricsPlugin: Plugin = async () => ({
  "chat.headers": async (input, output) => {
    if (input.model.providerID !== "bifrost") {
      return;
    }

    output.headers["x-bf-lh-session-id"] = input.sessionID;
    if (input.agent != null) {
      output.headers["x-bf-lh-agent"] = input.agent;
    }
  },
});
