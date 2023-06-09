import argparse
import getpass
import logging
import os
import sys
from typing import List

import boto3

# from dwarfcli.commands.command_factory import CommandFactory
# from dwarfcli.commands.dwarf_context import DwarfContext
from dwarfcli.config import *
from dwarfcli.io.input import Input
# from dwarfcli.svcs.observability.error_reporter import DwarfErrorReporter
# from dwarfcli.svcs.setup import DwarfSetup
from dwarfcli.utils.utils import Utils


root_logger = logging.getLogger()
root_logger.setLevel(logging.CRITICAL)
root_logger.handlers = []
stdout_handler = logging.StreamHandler(sys.stdout)

log = logging.getLogger(__name__)


class DwarfCLI:
    @staticmethod
    def add_arg(com_parser, com_arg, cmd, rsc):
        com_parser.add_argument(f'--{Utils.get_first(com_arg)}', help=HELP_TEXT_MAP[com_arg],
                                action=arg_options[rsc][cmd][com_arg][action],
                                required=arg_options[rsc][cmd][com_arg][required])

    @staticmethod
    def parse_args():
        """
        Parses Dwarf command line arguments and returns generic "args" object.
        """
        parser = argparse.ArgumentParser(description=RESOURCE_PARSER_DESC)
        parser.add_argument(f'--{Utils.get_first(configure)}', help=configURE_HELP_TEXT, action=store_true)
        parser.add_argument(f'--{Utils.get_first(prompt_com)}', help=PROMPT_HELP_TEXT, action=store_true)
        parser.add_argument(f'--{Utils.get_first(version)}', help=VERSION_HELP_TEXT, action=store_true)
        parser.add_argument(f'--{Utils.get_first(skip_upgrade)}', help=SKIP_UPGRADE_HELP_TEXT, action=store_true)
        parser.add_argument(f'--{Utils.get_first(upgrade)}', help=UPGRADE_HELP_TEXT, action=store_true)

        resource_subparsers = parser.add_subparsers(title='resources', dest='resource', metavar='')

        for rsc in resource_map:
            cmd_parser = resource_subparsers.add_parser(Utils.get_first(rsc), help=HELP_TEXT_MAP[rsc])
            subparser = cmd_parser.add_subparsers(title=f'{Utils.get_first(rsc)} commands', dest='command', metavar='',
                                                  help=HELP_TEXT_MAP[rsc])

            for cmd in resource_map[rsc]:
                com_parser = subparser.add_parser(Utils.get_first(cmd), help=HELP_TEXT_MAP[cmd])
                for com_arg, val in arg_options[rsc][cmd].items():
                    DwarfCLI.add_arg(com_parser, com_arg, cmd, rsc)

        return parser.parse_args()

    # def get_profile(self, prompt: bool) -> str:
    #     """Returns the user's profile.
    #     Checks ENV variable, if not there, checks the config file (created via the --configure option), otherwise prompts
    #     the user
    #     Args:
    #         prompt: True/False - if True, users will always be prompted to input their profile
    #     :return: str: aws profile name
    #     """
    #
    #     if BASTION_PROFILE_ENV_NAME in os.environ and not prompt:
    #         return os.environ.get(BASTION_PROFILE_ENV_NAME)
    #     else:
    #         defaults: CLIDefaults = DwarfSetup.stc_get_defaults(self._is_setup_command, profile=self._profile)
    #         if defaults is not None and not prompt:
    #             return defaults.provider_config.profile
    #         else:
    #             return Input.select_aws_cli_profile()
    #
    # def get_role(self, prompt: bool, role_override: str = None, is_setup: bool = False) -> Role:
    #     """
    #     Returns a string of the user's selected role.
    #     Lookup the user's default role from the config file (created via the --configure option), an ENV variable, or
    #     instead prompt the user for the session.
    #     :param prompt: True/False - if True, users will always be prompted to input their role
    #     :param role_override: String representation of the role to get, regardless of defaults.
    #     :return: str: name of the selected role.
    #     """
    #
    #     defaults = DwarfSetup.stc_get_defaults(self._is_setup_command, profile=self._profile)
    #     if defaults is not None and not prompt:
    #
    #         if role_override:
    #             if role_override in [role.role.role for role in defaults.assumable_roles] or is_setup:
    #                 return Role(role_override)
    #             else:
    #                 self._utils.error_exit(f"Invalid role override provided of: {role_override}. "
    #                                        f"You do not have permissions to assume this role. Contact your system "
    #                                        f"administrator to receive permissions then rerun `{CLI_NAME} "
    #                                        f"--{Utils.get_first(configure)}`.")
    #
    #         return defaults.role
    #     else:
    #         roles = self.__setup().get_assumable_roles()
    #         role_names = list(set([x.role.role for x in roles]))
    #         return Input.select_role(role_names)
    #
    # def get_colors_enabled(self) -> bool:
    #     """
    #     Defaults to true, unless user ran --configure and disabled colored output
    #     Returns: True/False
    #     """
    #
    #     defaults = DwarfSetup.stc_get_defaults(skip=self._is_setup_command, profile=self._profile)
    #     if defaults is not None:
    #         return defaults.colors_enabled
    #     else:
    #         return Utils.not_windows()
    #
    # def get_command(self) -> Command:
    #     """
    #     Maps the user's passed in text command to one of our defined 'command' objects we use in the code.
    #     Args:
    #     Returns: command object.
    #     """
    #     return self.__command_factory().instance()
    #
    # def find_assumable_role(self, env: RunEnv, role: Role, skip: bool = False, profile=None) -> AssumableRole:
    #     """
    #     Looks up the appropriate assumable role based on the user's selected defaults or command-line overrides for
    #     --env, --role, and --profile.
    #     """
    #
    #     if profile:
    #         return AssumableRole.from_profile(profile)
    #
    #     assumable_roles: List[AssumableRole] = DwarfSetup.stc_get_defaults(skip=skip).assumable_roles
    #     matching_role = [ar for ar in assumable_roles if ar.role == role and ar.run_env == env]
    #     if matching_role:
    #         matching_role = matching_role.pop()
    #     else:
    #         if not skip:
    #             matching_role = None
    #         else:
    #             matching_role = AssumableRole.default_from_role_env(role, env)
    #
    #     return matching_role
    #
    # def __setup(self) -> DwarfSetup:
    #     if not self._setup:
    #         self._setup = DwarfSetup()
    #
    #     return self._setup
    #
    # def __command_factory(self) -> CommandFactory:
    #     if not self._command_factory:
    #         self._command_factory = CommandFactory(self._context,
    #                                                DwarfSetup.stc_get_defaults(skip=self._is_setup_command,
    #                                                                            profile=self._profile))
    #
    #     return self._command_factory

    @staticmethod
    def is_setup_command(args):
        """
        Returns True for 'special' commands that configure dwarf itself or follow non-normal executiion paths.
        Needed to skip past steps that are not necessary because dwarf isn't set up yet, or to support a special
        use case (like sandbox logins).
        """
        return Utils.is_set_true(configure, args) \
               or Utils.command_set(sandbox, args) \
               or Utils.is_set_true(version, args) \
               or Utils.attr_exists(profile, args) \
               or Utils.is_set_true(upgrade, args)

    def __init__(self, args):
        """
        Initializes global shared properties
        :param args: Arguments passed in from user, collected from ArgParse
        """
        self._profile = None
        self._command_factory = None
        self._setup = None
        self._is_setup_command: bool = DwarfCLI.is_setup_command(args)
        self._utils = Utils(self.get_colors_enabled())
        self._profile = Utils.attr_if_exists(profile, args)
        self._defaults: CLIDefaults = DwarfSetup.stc_get_defaults(skip=self._is_setup_command, profile=self._profile)
        self._run_env = self._defaults.run_env
        role_override = Utils.attr_if_exists(role, args)
        self._role: Role = self.get_role(args.prompt, role_override=role_override, is_setup=self._is_setup_command)

        if not self._is_setup_command:
            if not hasattr(args, 'env') or args.env is None:
                print(f"{EMPTY_ENV_HELP_TEXT}{self._run_env.env}\n")
            else:
                Utils.stc_validate(args.env in self._defaults.valid_envs,
                                   f'{ENV_HELP_TEXT} {self._defaults.valid_envs}. Provided: {args.env}')
                self._run_env = RunEnv(args.env)

        self._utils.validate(Utils.attr_exists(configure, args) or Utils.attr_exists(command, args),
                             f"No command found. Proper format is `{CLI_NAME} <resource> <command> --option(s)`")

        self._assumable_role = self.find_assumable_role(self._run_env, self._role, skip=self._is_setup_command,
                                                        profile=self._profile)

        command_val = Utils.attr_if_exists(command, args)
        resource_val = Utils.attr_if_exists(resource, args)
        found_command: frozenset = frozenset({Utils.attr_if_exists(command, args)}) if command_val else None
        found_resource: frozenset = frozenset({Utils.attr_if_exists(resource, args)}) if resource_val else None

        self._context = DwarfContext(self.get_colors_enabled(), found_resource, found_command,
                                     self._run_env, self._assumable_role, args)


def main():
    """
        Entrypoint to dwarf.
        Performs generic validation, then routes user down appropriate execution path based on command line parameters
    """
    arguments = sys.argv
    user = getpass.getuser()
    Utils.stc_validate(user != ROOT_USER, f"Hey! Stop trying to run {CLI_NAME} as {ROOT_USER}. That's bad!")
    original_command = ' '.join(arguments)
    sys.argv = arguments
    try:
        # Parse / Validate Args
        args = DwarfCLI.parse_args()
        if hasattr(args, 'debug') and args.debug:
            root_logger.setLevel(logging.INFO)
            root_logger.addHandler(stdout_handler)

        cli: DwarfCLI = DwarfCLI(args)
        command: Command = cli.get_command()

        if hasattr(args, 'info') and args.info:
            command.print_help_text()
        else:
            command.execute()

    except AssertionError as e:
        Utils.stc_error_exit(e.args[0])
    except KeyboardInterrupt:
        pass
    except Exception as e:
        try:
            error_reporter = DwarfErrorReporter(DwarfSetup.stc_get_defaults(skip=True, profile=None))
            error_reporter.log_error(original_command, e)
        except Exception as e:
            print(e)
            print(f"\n\nUnable to log or report this exception. Please submit a Github issue to: {DWARF_GITHUB}")


if __name__ == '__main__':
    try:
        main()
    except Warning:
        pass
