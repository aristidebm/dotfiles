# Specialisation plumbing. Variants are added later, e.g.:
#
#   specialisation."<name>" = {
#     configuration = {
#       home.packages = [ ... ];
#     };
#   };
#
# Activate one with:
#   $home-generation/specialisation/<name>/activate
{ ... }:

{
  specialisation = { };
}